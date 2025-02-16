@tool
extends MeshInstance3D

@export var lava_size: Vector2 = Vector2(50, 50):
	set(new):
		lava_size = new
		mesh.size = new

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
