extends BTAction

@export var target_pos_var := &"selected_pos"
@export var tolerance := 1

var target_pos: Vector3

func _enter() -> void:
	target_pos = blackboard.get_var(target_pos_var, Vector3.ZERO)

func _tick(delta: float) -> Status:
	var d: Vector3 = target_pos - agent.global_position
	var dir: Vector3 = d.normalized()
	if (abs(d.length()) <= tolerance):
		print("STOPPED")
		agent.stop()
		return SUCCESS
	
	agent.walk_toward(dir, delta)
	return RUNNING
