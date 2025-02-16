class_name NarrateArea
extends Area3D

@export var audio: AudioStream
@export var only_once: bool = true
@export_multiline var subtitle: String = "<!!! TODO SUBTITLE !!!>"

@onready var subtitle_label: Label = %SubtitleLabel

var done: bool = false

func _ready() -> void:
	assert(audio, "No audio Selected for " + name)
	subtitle_label.text = ""


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		if only_once and done:
			return
		done = true
		subtitle_label.text = subtitle
		await body.say(audio)
		subtitle_label.text = ""
