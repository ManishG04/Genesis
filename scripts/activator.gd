class_name Activator
extends Node3D

@export var activatable: Activatable
var activated: bool = false

func _ready() -> void:
	if not activatable:
		push_error("No activatable attached to " + name)

func after_activate() -> void:
	push_error("after_activate not implemented on " + name)
	
func after_deactivate() -> void:
	push_error("after_deactivate not implemented on " + name)

func activate() -> void:
	activated = true
	activatable.on_activate()
	after_activate()

func deactivate() -> void:
	activated = false
	activatable.on_deactivate()
	after_deactivate()
