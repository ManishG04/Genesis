class_name NPC
extends CharacterBody3D

@export var navigation: NavigationAgent3D
@export var animated_sprite: AnimatedSprite3D
@export_range(0, 10, .01, "suffix:secs") var move_throttle_time: float = 1.0

@export var WALK_SPEED = 2.0
@export var SPRINT_SPEED = 4.0
@export var JUMP_VELOCITY = 4.5
@export var FRICTION = .5
@export var grounded: bool = true

@onready var spawn_pos: Vector3 = global_position

var locked_animations: bool = false
var is_moving: bool = false

func move(sprint: bool = false):
	if is_moving: return
	is_moving = true
	var next_path = navigation.get_next_path_position()
	var move_direction = global_position.direction_to(next_path)
	var prev_y = velocity.y
	velocity = move_direction * (SPRINT_SPEED if sprint else WALK_SPEED)
	if sprint:
		animated_sprite.speed_scale = 1.2
	else:
		animated_sprite.speed_scale = 1
	await get_tree().create_timer(move_throttle_time).timeout
	is_moving = false
	velocity.y = prev_y
	#print(velocity)

#func walk_toward(dir: Vector3, delta: float) -> void:
	#velocity = dir * WALK_SPEED
	#velocity.y = 0
	#
#func sprint_toward(dir: Vector3, delta: float) -> void:
	#velocity = dir * SPRINT_SPEED
	#velocity.y = 0
	
func _handle_animations():
	if locked_animations: return
	if abs(velocity.x) > 0 || abs(velocity.z) > 0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
	
func stop() -> void:
	velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	if not is_on_floor() and grounded:
		velocity += get_gravity() * delta
		
	_handle_animations()
	move_and_slide()
