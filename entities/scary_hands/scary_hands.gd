class_name ScaryHands
extends Activatable
@onready var ap: AnimationPlayer = $AnimationPlayer

func on_activate():
	ap.play("appear")
	
func on_deactivate():
	pass
