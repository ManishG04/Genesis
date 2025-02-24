extends BTAction

@export var max_dist: float = 10

var npc: NPC
var rng: RandomNumberGenerator

func _setup() -> void:
	npc = agent as NPC
	rng = RandomNumberGenerator.new()
	
func _enter() -> void:
	npc.navigation.target_position = pick_destination()
	
func _tick(delta: float) -> Status:
	if npc.navigation.is_navigation_finished():
		npc.stop()
		return SUCCESS
	
	if not npc.navigation.is_target_reachable():
		npc.stop()
		return FAILURE
	
	npc.move()
	
	return RUNNING
	
	
func pick_destination() -> Vector3:
	var curr_pos = npc.spawn_pos
	var offsetx = rng.randf_range(-max_dist, max_dist)
	var offsetz = rng.randf_range(-max_dist, max_dist)
	var new_pos = Vector3(
		curr_pos.x + offsetx,
		curr_pos.y,
		curr_pos.z + offsetz
	)
	return new_pos
