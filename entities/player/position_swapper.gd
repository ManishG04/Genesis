class_name PositionSwapper
extends Node

@export var enabled: bool = true
@onready var camera: Node3D = %Head/Camera3D
@onready var player: Player = $"../.."
@onready var aim_ray_cast: RayCast3D = %AimRayCast

@onready var hand_sprite: Sprite3D = %HandSprite

# Properties
var can_swap: bool = true
var swap_cooldown: float = 1.0  # Time between swaps
var max_swap_distance: float = 6.0
var current_cooldown: float = 0.0

func _ready() -> void:
	assert(player)
	if hand_sprite:
		hand_sprite.frame = 0

func _physics_process(delta: float) -> void:
	if not enabled:
		return
		
	if current_cooldown > 0:
		current_cooldown -= delta

func handle_ability() -> void:
	if not enabled:
		return
		
	if current_cooldown <= 0:
		on_ready_to_swap()
		if hand_sprite:
			hand_sprite.frame = 0
	else:
		if hand_sprite:
			hand_sprite.frame = 1

func on_ready_to_swap() -> void:
	var collision_object = aim_ray_cast.get_collider() as MoveableRB
	if collision_object != null and can_be_swapped(collision_object):
		on_swappable_collision(collision_object)

func on_swappable_collision(collision_object: MoveableRB) -> void:
	# Check if within max distance
	var distance = collision_object.global_position.distance_to(player.global_position)
	if distance > max_swap_distance:
		return
		
	if Input.is_action_just_pressed("shoot") and current_cooldown <= 0:
		perform_swap(collision_object)

func perform_swap(object: MoveableRB) -> void:
	# Store original positions
	var player_pos = player.global_position
	var object_pos = object.global_position
	
	# Enable continuous collision detection temporarily
	object.contact_monitor = true
	object.set_deferred("continuous_cd", true)
	
	# Reset the object's physics state
	object.freeze = true  # Temporarily freeze the object
	object.linear_velocity = Vector3.ZERO
	object.angular_velocity = Vector3.ZERO
	
	# Perform the swap
	player.global_position = object_pos
	
	# Use call_deferred to ensure the physics engine handles the teleport properly
	call_deferred("_complete_swap", object, player_pos)
	
	# Start cooldown
	current_cooldown = swap_cooldown

func _complete_swap(object: MoveableRB, target_pos: Vector3) -> void:
	# Set the position
	object.global_position.x = target_pos.x
	object.global_position.y = target_pos.y + 1
	
	# Re-enable physics after a short delay to ensure proper collision detection
	await get_tree().create_timer(0.1).timeout
	object.freeze = false
	
	# Keep continuous collision detection for a bit longer
	await get_tree().create_timer(0.5).timeout
	object.set_deferred("continuous_cd", false)

func can_be_swapped(object) -> bool:
	# Only allow MoveableRB objects to be swapped
	return object is MoveableRB and object.has_method("apply_central_force")
