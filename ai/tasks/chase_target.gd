extends BTAction

@export var tolerance: float = 3

var npc: NPC
var target: Node3D

func _setup() -> void:
	npc = agent as NPC
	
func _enter() -> void:
	#target = blackboard.get_var("target_var")
	pass
	
func _tick(delta: float) -> Status:
	target = blackboard.get_var("target_var")
	if not target:
		npc.stop()
		return FAILURE
		
	npc.navigation.target_position = pick_destination()
	
		
	if npc.navigation.is_navigation_finished():
		npc.stop()
		return SUCCESS
	
	if not npc.navigation.is_target_reachable():
		npc.stop()
		return FAILURE
	
	npc.move(true)
	
	return RUNNING
	
	
func pick_destination() -> Vector3:
	var new_pos = target.global_position
	return new_pos
