extends BTAction

@export var radius: float = 6.0
@export var selected_pos_var: StringName = &"selected_pos"

var spawn_pos: Vector3
func _enter() -> void:
	spawn_pos = agent.get_spawn_pos()

func _tick(delta: float) -> Status:
	var pos = random_pos(spawn_pos)
	blackboard.set_var(selected_pos_var, pos)
	return SUCCESS

func random_pos(origin: Vector3) -> Vector3:
	var x: float = randf_range(origin.x - radius, origin.x + radius)
	var y: float = origin.y;
	var z: float = randf_range(origin.z - radius, origin.z + radius)
	var pos: Vector3 = Vector3(x, y, z)
	return pos
