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
	var tween = create_tween()
	if new:
		tween.tween_property(mat, "shader_parameter/size", 1.1, .25)
	else:
		tween.tween_property(mat, "shader_parameter/size", 1.0, .25)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(meshInstance, "Mesh Instance not selected")
	var mat = meshInstance.material_overlay as ShaderMaterial
	assert(mat.get_shader_parameter("size"), "Size propery does not exist on the shader overlay")
	
