@tool
extends BTAction
## LeapToTarget

@export var target_var: StringName = &"target_var"

var target: Node3D
var npc: GroundedNPC

# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "Leap To Target"


# Called once during initialization.
func _setup() -> void:
	npc = agent as GroundedNPC


# Called each time this task is entered.
func _enter() -> void:
	pass


# Called each time this task is exited.
func _exit() -> void:
	pass


# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	target = blackboard.get_var(target_var)
	npc.leap(npc.global_position.direction_to(target.global_position))
	return SUCCESS
