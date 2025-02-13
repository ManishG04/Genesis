class_name Util
extends Node

enum ABILITIES {
	GRAB,
	SWAP,
	PROJECTILE_THROWER,
	TIME_STOPPER,
}

enum PROJECTILE_TYPES {
	SOUL,
}
# This function sets a CollisionObject3D to a specific collision layer.
# Note: In the editor the layers are 1-indexed (i.e. layer 1, layer 2, …)
# but in code, the bit corresponding to layer 1 is the 0th bit.
static func move_collision_object_to_layer(obj: CollisionObject3D, layer: int) -> void:
	# Optional: Validate that the layer number is in a valid range (usually 1-20)
	if layer < 1 or layer > 20:
		push_error("Layer must be between 1 and 20!")
		return
	# Set the object's collision_layer so that only the specified layer is active.
	# For example, layer 3 means 1 << (3 - 1) == 1 << 2.
	obj.collision_layer = 1 << (layer - 1)
