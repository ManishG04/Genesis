class_name TimeStopper
extends Node

@export var enabled: bool = true

func handle_ability():
	if not enabled: return
	if Input.is_action_pressed("shoot"):
		#get_tree().paused = true
		Engine.time_scale = 0.2
	else:
		Engine.time_scale = 1.0
		#get_tree().paused = false
