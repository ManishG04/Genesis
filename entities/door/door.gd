class_name Door
extends Activatable


@export var is_interactable: bool = true
@export var is_open: bool = false

@onready var ap: AnimationPlayer = $AnimationPlayer
@onready var interactable_area: InteractableArea = $InteractableArea

func _ready() -> void:
	interactable_area.enabled = is_interactable
	if is_open:
		open()
	else:
		close()

func on_activate() -> void:
	open()

func on_deactivate() -> void:
	close()

func open() -> void:
	ap.play("open")
	is_open = true

func close() -> void:
	ap.play_backwards("open")
	is_open = false
	
func _on_interactable_area_interacted() -> void:
	if is_open:
		close()
	else:
		open()
