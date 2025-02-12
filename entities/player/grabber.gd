class_name Grabber
extends Node

@export var enabled: bool = true

@onready var camera: Node3D = %Head/Camera3D
@onready var hand_sprite: Sprite3D = %HandSprite
@onready var player: Player = $"../.."
@onready var aim_ray_cast: RayCast3D = %AimRayCast

var grabbed_item: MoveableRB = null
var grabbed_item_rel_pos: Vector3 = Vector3.ZERO
var grab_strength: float = 30.0
var max_grab_distance: float = 6.0

# New variables for throw mechanics
var previous_positions: Array[Vector3] = []
var max_positions: int = 5  # Store last 5 positions for velocity calculation
var position_update_interval: float = 0.02  # 50 times per second
var time_since_last_update: float = 0.0

func _ready() -> void:
	assert(player)

func _physics_process(delta: float):
	if grabbed_item:
		time_since_last_update += delta
		if time_since_last_update >= position_update_interval:
			time_since_last_update = 0.0
			previous_positions.push_back(grabbed_item.global_position)
			if previous_positions.size() > max_positions:
				previous_positions.pop_front()

func handle_ability():
	if not enabled: return
	if grabbed_item == null:
		on_empty_grabber()
		hand_sprite.frame = 0
	else:
		_on_grabbed(grabbed_item)
		on_full_grabber()
		hand_sprite.frame = 1

func on_empty_grabber():
	var collision_object = aim_ray_cast.get_collider() as MoveableRB
	if collision_object != null:
		on_grabber_collision(collision_object)
		#collision_object.set_collision_layer_value(1, false)

func on_full_grabber():
	if grabbed_item == null:
		return
	grabbed_item.aimed = true
	#grabbed_item.set_collision_layer_value(1, true)
	# Calculate expected position
	var expected_translation = camera.to_global(grabbed_item_rel_pos)
	
	# Prevent object from going too far
	var current_distance = grabbed_item.global_position.distance_to(camera.global_position)
	if current_distance > max_grab_distance:
		let_go()
		return

	# Calculate the direction and distance
	var direction = (expected_translation - grabbed_item.global_position)
	var distance = direction.length()
	
	if distance > 0.1:
		var force = direction.normalized() * grab_strength
		grabbed_item.apply_central_force(force)
		
		# Add torque dampening to reduce spinning
		grabbed_item.angular_velocity *= 0.95
		grabbed_item.linear_velocity *= 0.9
	
	# Release the object when the button is released
	if !Input.is_action_pressed("shoot"):
		let_go()

func let_go():
	grabbed_item.aimed = false
	_on_let_go(grabbed_item)
	if grabbed_item and previous_positions.size() >= 2:
		# Calculate velocity from previous positions
		var throw_velocity = Vector3.ZERO
		for i in range(previous_positions.size() - 1):
			throw_velocity += (previous_positions[i + 1] - previous_positions[i]) / position_update_interval
		
		throw_velocity /= (previous_positions.size() - 1)  # Average velocity
		
		# Apply the throwing velocity
		grabbed_item.linear_velocity = throw_velocity
		
		# Reset CCD
		grabbed_item.set_deferred("continuous_cd", false)
	
	# Clear the position history
	previous_positions.clear()
	grabbed_item = null
	
func _on_grabbed(obj: MoveableRB):
	if not obj: return
	Util.move_collision_object_to_layer(obj, 4)

func _on_let_go(obj: MoveableRB):
	if not obj: return
	Util.move_collision_object_to_layer(obj, 2)

func on_grabber_collision(collision_object: MoveableRB):
	if can_be_picked(collision_object):
		if Input.is_action_pressed("shoot"):
			collision_object.aimed = true
			grabbed_item_rel_pos = camera.to_local(collision_object.global_position)
			grabbed_item = collision_object
			
			# Enable continuous collision detection
			grabbed_item.set_deferred("continuous_cd", true)
			grabbed_item.angular_velocity = Vector3.ZERO  # Reset any existing rotation

func can_be_picked(object):
	return object.has_method("apply_central_force")
