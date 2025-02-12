class_name Explosion
extends Area3D

@export var radius: float = 10.0
@export var force: float = 50.0
@export var expansion_speed: float = 10.0
@onready var col: CollisionShape3D = $CollisionShape3D
@onready var explosion: GPUParticles3D = $Explosion

var shape: SphereShape3D

func _ready() -> void:
	shape = col.shape as SphereShape3D
	shape.radius = 0
	explosion.emitting = true

func _process(delta: float) -> void:
	shape.radius += expansion_speed * delta
	if shape.radius >= radius:
		col.disabled = true
		await explosion.finished
		queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		print(body.name)
		var normal = (body.global_position - global_position).normalized()
		body.apply_central_impulse(force * normal)
