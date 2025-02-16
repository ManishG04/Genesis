extends Control

@onready var subtitle_label: Label = %SubtitleLabel

func _ready() -> void:
	clear()

func _process(delta: float) -> void:
	pass

func set_text(text: String) -> void:
	subtitle_label.text = text

func clear() -> void:
	subtitle_label.text = ""
