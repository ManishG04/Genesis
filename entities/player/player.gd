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

var health := 100.0
var stamina := 100.0:
	set(new):
		stamina = clamp(new, 0, 100)
		_on_update_stamina(new)

@onready var head: Node3D = %Head
@onready var camera: Camera3D = %Head/Camera3D
@onready var stamina_bar: TextureProgressBar = %StaminaBar
@onready var aim_ray_cast: RayCast3D = %AimRayCast
@onready var speed_indicator: SpeedIndicator = %SpeedIndicator


var t_bob = 0.0
var speed = 0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("sprint"):
		stamina -= STAMINA_DELTA
		speed = SPRINT_SPEED
	else:
		stamina += STAMINA_DELTA
		speed = WALK_SPEED
	if stamina <= 0:
		speed = WALK_SPEED
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
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
	t_bob += delta * velocity.length() * float(is_on_floor()) + .025
	camera.transform.origin = _headbob(t_bob)
	var velocity_clamped = clamp(Vector2(velocity.x, velocity.z).length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	if speed >= SPRINT_SPEED:
		speed_indicator.speed_up()
	else:
		speed_indicator.slow_down()
	move_and_slide()
	_push_pushables(delta)
	
func _headbob(time: float) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ/2) * BOB_AMP
	return pos

func _push_pushables(delta: float) -> void:
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
