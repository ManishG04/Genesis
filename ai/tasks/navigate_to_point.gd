extends BTAction

@export var max_dist: float = 10
@export var flying_tolerance: float = 2

var npc: NPC
var rng: RandomNumberGenerator

var dest: Vector3

func _setup() -> void:
	rng = RandomNumberGenerator.new()
	npc = agent as NPC
	
func _enter() -> void:
	dest = pick_destination()
	
func _tick(delta: float) -> Status:
	if npc is GroundedNPC:
		return grounded_navigate(npc)
	return flying_navigate(npc)
	
	
func flying_navigate(npc: FlyingNPC) -> Status:
	npc.move(dest)
	if npc.global_position.distance_squared_to(dest) <= flying_tolerance:
		return SUCCESS
	return RUNNING
	
func grounded_navigate(npc: GroundedNPC) -> Status:
	npc.navigation.target_position = dest
	if npc.navigation.is_navigation_finished():
		npc.stop()
		return SUCCESS
	if not npc.navigation.is_target_reachable():
		npc.stop()
		return FAILURE
	npc.navigate()
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
