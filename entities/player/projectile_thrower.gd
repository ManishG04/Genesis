class_name ProjectileThrower
extends Node

@export var enabled: bool = true
@export var projectile_type: Util.PROJECTILE_TYPES = Util.PROJECTILE_TYPES.SOUL

@onready var aim_ray_cast: RayCast3D = %AimRayCast
@onready var camera: Camera3D = $%Head/Camera3D
const SOUL_PROJECTILE = preload("res://entities/soul_projectile.tscn")

func _ready():
	pass

func handle_ability():
	if not enabled: return
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	var projectile: Projectile
	match projectile_type:
		Util.PROJECTILE_TYPES.SOUL:
			projectile = SOUL_PROJECTILE.instantiate()
	#projectile.global_position = owner.global_position
	#projectile.global_rotation = camera.global_rotation
	projectile.global_transform = camera.global_transform
	print(owner.name)
	get_tree().root.add_child(projectile)
