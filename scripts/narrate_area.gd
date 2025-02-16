class_name NarrateArea
extends Area3D

@export var only_once: bool = true
@export var audio_list: Array[AudioStream] = []
@export_multiline var subtitle_list: Array[String] = []

var done: bool = false

func _ready() -> void:
	assert(len(audio_list), "No audio files selected for " + name)
	assert(len(audio_list) == len(subtitle_list), "Subtitles list must have same number of elements as audio list" + name)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		if only_once and done:
			return
		done = true
		for i in len(audio_list):
			body.say(audio_list[i], subtitle_list[i])
