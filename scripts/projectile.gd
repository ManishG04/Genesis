class_name Projectile
extends Area3D

@export var speed: float = 10
@onready var visuals: Node3D = $Visuals
@onready var particles: CPUParticles3D = $Visuals/CPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += -transform.basis.z * speed * delta



func _on_body_entered(body: Node3D) -> void:
	var tween = create_tween()
	particles.emitting = false
	tween.tween_property(visuals, "scale", Vector3(0.0, 0.0, 0.0), particles.lifetime)
	tween.call_deferred("queue_free")
	speed = 0
