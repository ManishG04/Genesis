class_name Door
extends Activatable

@export var is_interactable: bool = true
@export var is_open: bool = false
@export_range(0, 10, .05, "suffix:s") var opening_time: float = 0.25
@export_range(0, 10, .05, "suffix:s") var close_delay: float = 0.0

@export var show_debug_label: bool = false

@onready var ap: AnimationPlayer = $AnimationPlayer
@onready var interactable_area: InteractableArea = $InteractableArea
@onready var close_delay_timer: Timer = $CloseDelayTimer
@onready var close_delay_timer_label: Label3D = $CloseDelayTimerLabel

func _ready() -> void:
	interactable_area.enabled = is_interactable
	ap.speed_scale = 1 / opening_time
	if is_open:
		open()
	else:
		close()
	if show_debug_label:
		close_delay_timer_label.show()
	else:
		close_delay_timer_label.hide()

func _process(delta: float) -> void:
	if show_debug_label:
		close_delay_timer_label.text = "%.2f" % close_delay_timer.time_left + "s"

func on_activate() -> void:
	close_delay_timer.stop()
	open()

func on_deactivate() -> void:
	if close_delay > 0:
		close_delay_timer.start(close_delay)
	else:
		close()

func open() -> void:
	if is_open: return
	ap.play("open")
	is_open = true

func close() -> void:
	if not is_open: return
	ap.play("close")
	is_open = false
	
func _on_interactable_area_interacted() -> void:
	if is_open:
		close()
	else:
		open()


func _on_close_delay_timer_timeout() -> void:
	close()
