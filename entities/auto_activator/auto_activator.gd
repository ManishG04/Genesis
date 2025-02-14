class_name AutoActivator
extends Activator


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		activate()

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		deactivate()
