class_name InteractableButton
extends Activator

@export var auto_deactivate: bool = true
@export_range(0, 10, .05, "suffix:s") var auto_deactivate_time: float = 1.0

@onready var ap: AnimationPlayer = $AnimationPlayer
@onready var auto_deactivate_timer: Timer = $AutoDeactivateTimer

func after_activate() -> void:
	ap.play("press")
	if auto_deactivate:
		auto_deactivate_timer.start(auto_deactivate_time)

func after_deactivate() -> void:
	ap.play_backwards("press")


func _on_interactable_area_interacted() -> void:
	if not activated:
		activate()
	elif not auto_deactivate:
		deactivate()


func _on_auto_deactivate_timer_timeout() -> void:
	deactivate()
