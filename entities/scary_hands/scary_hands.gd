class_name ScaryHands
extends Activatable
@onready var ap: AnimationPlayer = $AnimationPlayer

func on_activate():
	ap.play("appear")
	Global.player.scare()
	
func on_deactivate():
	pass
