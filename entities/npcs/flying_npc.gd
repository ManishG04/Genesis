class_name FlyingNPC
extends NPC

func move(target_pos: Vector3, sprint: bool = false):
	if sprint: 
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	velocity = global_position.direction_to(target_pos) * speed
	if sprint:
		animated_sprite.speed_scale = 1.2
	else:
		animated_sprite.speed_scale = 1

#func walk_toward(dir: Vector3, delta: float) -> void:
	#velocity = dir * WALK_SPEED
	#velocity.y = 0
	#
#func sprint_toward(dir: Vector3, delta: float) -> void:
	#velocity = dir * SPRINT_SPEED
	#velocity.y = 0
	
