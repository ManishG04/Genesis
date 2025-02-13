class_name Activator
extends Node3D

@export var activatable: Activatable

func _ready() -> void:
	assert(activatable, "No activatable attached to " + name)

func after_activate() -> void:
	push_error("after_activate not implemented on " + name)
	
func after_deactivate() -> void:
	push_error("after_deactivate not implemented on " + name)

func activate() -> void:
	activatable.on_activate()
	after_activate()

func deactivate() -> void:
	activatable.on_deactivate()
	after_deactivate()
