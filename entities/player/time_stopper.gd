class_name TimeStopper
extends Node

@export var enabled: bool = true
@onready var hand_sprite: Sprite3D = %HandSprite

func handle_ability():
	if not enabled: return
	if Input.is_action_pressed("shoot"):
		Engine.time_scale = 0.1
		hand_sprite.frame = 1
	else:
		hand_sprite.frame = 0
		Engine.time_scale = 1.0
