class_name FloorButton
extends Activator
@onready var ap: AnimationPlayer = $AnimationPlayer

func after_activate() -> void:
	ap.play("press")

func after_deactivate() -> void:
	ap.play_backwards("press")


func _on_button_area_area_entered(area: Area3D) -> void:
	activate()


func _on_button_area_area_exited(area: Area3D) -> void:
	deactivate()


func _on_button_area_body_entered(body: Node3D) -> void:
	activate()


func _on_button_area_body_exited(body: Node3D) -> void:
	deactivate()
