class_name Activatable
extends Node3D

func on_activate() -> void:
	push_error("Activate function not implemented ", owner.name)

func on_deactivate() -> void:
	push_error("Deactivate function not implemented ", owner.name)
