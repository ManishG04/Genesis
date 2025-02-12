extends RayCast3D

var aimed_at: MoveableRB = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var col = get_collider() as MoveableRB
	if is_colliding() and col:
		if col is MoveableRB:
			if aimed_at: aimed_at.aimed = false
			aimed_at = col
			col.aimed = true
		else:
			if aimed_at:
				aimed_at.aimed = false
				aimed_at = null
	else:
		if aimed_at:
			aimed_at.aimed = false
			aimed_at = null
