class_name MoveableRB
extends RigidBody3D

@export var meshInstance: MeshInstance3D

var linear_vel = null
var aimed: bool = false:
	set(new):
		aimed = new
		_on_aimed_updated(new)

func _on_aimed_updated(new: bool):
	var mat = meshInstance.material_overlay as ShaderMaterial
	if not mat: return
	if new:
		mat.set_shader_parameter("size", 1.1)
	else:
		mat.set_shader_parameter("size", 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(meshInstance)
	
