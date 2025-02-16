class_name Player
extends CharacterBody3D

@export var WALK_SPEED = 4.0
@export var SPRINT_SPEED = 8.0
@export var STAMINA_DELTA = .5
@export var JUMP_VELOCITY = 4.5
@export var SENSITIVITY = 0.01
#bob variables
@export var BOB_FREQ = 2.0
@export var BOB_AMP = 0.08
#fov variables
@export var BASE_FOV = 75.
@export var FOV_CHANGE = 1.5
# Debug mode variables
@export var DEBUG_FLY_SPEED = 10.0
var debug_mode := false
var original_collision_mask: int

var health := 100.0
var stamina := 100.0:
	set(new):
		stamina = clamp(new, 0, 100)
		_on_update_stamina(new)

@onready var head: Node3D = %Head
@onready var camera: Camera3D = %Camera3D
@onready var stamina_bar: TextureProgressBar = %StaminaBar
@onready var aim_ray_cast: RayCast3D = %AimRayCast
@onready var speed_indicator: SpeedIndicator = %SpeedIndicator
@onready var narration_stream: AudioStreamPlayer = %NarrationStream
@onready var footsteps_stream: AudioStreamPlayer = %FootstepsStream

var t_bob := 0.0
var speed := 0.0
var time_factor := 1.0
var narrations: Array[AudioStream] = []

func _ready() -> void:
	Global.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Store original collision mask for toggling noclip
	original_collision_mask = collision_mask
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(60))
	
	# Toggle debug mode with Tab key
	if event.is_action_pressed("toggle_debug"):
		toggle_debug_mode()
		
	if event.is_action_pressed("escape"):
		match Input.mouse_mode:
			Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func toggle_debug_mode() -> void:
	debug_mode = !debug_mode
	if debug_mode:
		# Enable noclip by setting collision mask to 0
		collision_mask = 0
		print("Debug mode enabled")
	else:
		# Restore original collision mask
		collision_mask = original_collision_mask
		# Reset vertical velocity when exiting debug mode
		velocity.y = 0
		print("Debug mode disabled")
	
func _physics_process(delta: float) -> void:
	time_factor = 1/Engine.time_scale
	delta *= time_factor
	
	if debug_mode:
		_handle_debug_movement(delta)
	else:
		_handle_normal_movement(delta)
	
	move_and_slide()
	if !debug_mode:
		_push_pushables(delta)

func _handle_debug_movement(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Vertical movement in debug mode
	if Input.is_action_pressed("jump"):
		direction.y = 1.0
	if Input.is_action_pressed("sprint"):  # You'll need to add this action in the input map
		direction.y = -1.0
	
	# Apply movement in all directions
	velocity = direction * DEBUG_FLY_SPEED * time_factor
	
	# Keep camera effects disabled in debug mode
	camera.transform.origin = Vector3.ZERO
	camera.fov = BASE_FOV

func _handle_normal_movement(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * time_factor
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * time_factor
	if Input.is_action_pressed("sprint"):
		stamina -= STAMINA_DELTA
		speed = SPRINT_SPEED
	else:
		stamina += STAMINA_DELTA
		speed = WALK_SPEED
	if stamina <= 0:
		speed = WALK_SPEED
	speed = speed * time_factor
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	# Head bob
	t_bob += delta/time_factor * velocity.length() * float(is_on_floor()) + .025
	camera.transform.origin = _headbob(t_bob)
	var velocity_clamped = clamp(Vector2(velocity.x, velocity.z).length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	if speed >= SPRINT_SPEED:
		speed_indicator.speed_up()
	else:
		speed_indicator.slow_down()

# Rest of the original functions remain unchanged
func _headbob(time: float) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ/2) * BOB_AMP
	if footsteps_stream.playing == false and is_on_floor() and velocity.length_squared() > 1:
		footsteps_stream.play()
		footsteps_stream.pitch_scale = randf_range(0.8, 1.2)
		footsteps_stream.volume_db = randf_range(-5, 0)
	return pos

func _push_pushables(delta: float) -> void:
	if get_tree().paused: return
	var col := get_last_slide_collision()

	if col:
		var col_collider := col.get_collider()
		var col_position := col.get_position()

		if not col_collider is RigidBody3D:
			return
				
		var push_direction := -col.get_normal()
		var push_position = col_position - col_collider.global_position
		col_collider.apply_impulse(push_direction * 20 * delta, push_position)

func _on_update_stamina(new: float):
	stamina_bar.value = new

func scare(trauma: float = 10.0):
	%ShakeableCameraHolder.add_trauma(trauma)

func say(audio_stream: AudioStream, subtitle: String):
	narrations.push_back(audio_stream)
	while len(narrations):
		#WAIT
		if narration_stream.playing:
			await narration_stream.finished
			
		#PLAY
		var curr_stream = narrations[0]
		narration_stream.stream = curr_stream
		narration_stream.play()
		Subtitle.set_text(subtitle)
		
		#WAIT
		await narration_stream.finished
		
		#CLEAR
		narration_stream.stream = null
		narrations.pop_front()
		Subtitle.clear()
