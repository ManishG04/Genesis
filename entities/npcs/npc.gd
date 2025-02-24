class_name NPC
extends CharacterBody3D

@export var animated_sprite: AnimatedSprite3D

@export var WALK_SPEED = 2.0
@export var SPRINT_SPEED = 4.0
@export var JUMP_SPEED = 5.0
@export var FRICTION = .5
@export var apply_gravity: bool = true

@onready var spawn_pos: Vector3 = global_position

var locked_animations: bool = false
var is_moving: bool = false

var speed = 0
var direction: Vector3 = Vector3.ZERO

func move(target_pos: Vector3, sprint: bool = false):
	pass

func jump():
	print("JUMP")
	velocity.y += JUMP_SPEED
	#direction.y = 1

func _handle_animations():
	if locked_animations: return
	if abs(velocity.x) > 0 || abs(velocity.y) > 0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
	
func stop() -> void:
	#velocity = Vector3.ZERO
	speed = 0

func _physics_process(delta: float) -> void:
	if not is_on_floor() and apply_gravity:
		velocity += get_gravity() * delta
	if is_on_floor():
		velocity += speed * direction.normalized() * delta
	_handle_animations()
	move_and_slide()
