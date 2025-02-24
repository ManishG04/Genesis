class_name GroundedNPC
extends NPC

@export var navigation: NavigationAgent3D
@export_range(0, 10, .01, "suffix:secs") var move_throttle_time: float = 1.0

func navigate(sprint: bool = false):
	if is_moving: return
	is_moving = true
	var next_path = navigation.get_next_path_position()
	var move_direction = global_position.direction_to(next_path)
	var prevy = velocity.y
	velocity = move_direction * (SPRINT_SPEED if sprint else WALK_SPEED)
	if sprint:
		animated_sprite.speed_scale = 1.2
	else:
		animated_sprite.speed_scale = 1
	#velocity.y = prevy
	#await get_tree().create_timer(move_throttle_time).timeout
	is_moving = false
	if move_direction.y > .5:
		jump()
	#velocity.y = prev_y
