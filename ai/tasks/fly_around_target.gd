
extends BTAction

@export var radius = 5.0  # Set the desired radius for the circular movement
@export var speed = 2.0   # Angular speed in radians per second
@export_range(0, 10, .01, "suffix:secs") var duration: float = 5.0

var npc: NPC
var target: Node3D

var start_time = 0
func _setup() -> void:
	npc = agent as FlyingNPC
	start_time = Time.get_ticks_msec() / 1000.0
	
func _enter() -> void:
	#target = blackboard.get_var("target_var")
	pass
	
func _tick(delta: float) -> Status:
	target = blackboard.get_var("target_var")
	if not target:
		npc.stop()
		return FAILURE
	
	return fly_around()

func fly_around() -> Status:
	var time_passed = Time.get_ticks_msec() / 1000.0
	
	if time_passed - start_time > duration:
		start_time = time_passed
		return SUCCESS
	
	var angle = speed * time_passed
	var dest = target.position + Vector3(cos(angle), 0, sin(angle)) * radius
	
	npc.move(dest, true)
	#if 
	
	return RUNNING

func pick_destination() -> Vector3:
	var new_pos = target.global_position
	return new_pos
