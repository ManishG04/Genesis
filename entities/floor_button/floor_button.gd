class_name FloorButton
extends Activator
@onready var ap: AnimationPlayer = $AnimationPlayer

var bodies = []

func after_activate() -> void:
	ap.play("press")

func after_deactivate() -> void:
	ap.play_backwards("press")


func _on_button_area_area_entered(area: Area3D) -> void:
	if area in bodies: return
	bodies.push_back(area)
	activate()


func _on_button_area_area_exited(area: Area3D) -> void:
	bodies.erase(area)
	if len(bodies) == 0:
		deactivate()


func _on_button_area_body_entered(body: Node3D) -> void:
	if body is StaticBody3D or body in bodies: return
	bodies.push_back(body)
	activate()


func _on_button_area_body_exited(body: Node3D) -> void:
	bodies.erase(body)
	if len(bodies) == 0:
		deactivate()
