class_name Projectile
extends Area3D

@export var speed: float = 10
@export var lifetime: float = 5

@onready var visuals: Node3D = $Visuals
@onready var particles: CPUParticles3D = $Visuals/CPUParticles3D
const EXPLOSION = preload("res://entities/explosion/explosion.tscn")

var is_dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var timer = get_tree().create_timer(lifetime)
	await timer.timeout
	die()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += -transform.basis.z * speed * delta

func _on_body_entered(body: Node3D) -> void:
	die()

func die():
	if is_dead: return
	is_dead = true
	var tween = create_tween()
	speed = 0
	create_explosion()
	particles.emitting = false
	tween.tween_property(visuals, "scale", Vector3(0.0, 0.0, 0.0), particles.lifetime)
	tween.call_deferred("queue_free")

func create_explosion():
	var exp = EXPLOSION.instantiate()
	exp.global_position = global_position
	get_tree().root.add_child(exp)
	pass
