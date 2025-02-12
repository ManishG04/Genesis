extends RayCast3D

var aimed_at: MoveableRB = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var col = get_collider() as MoveableRB
	if col and col is MoveableRB:
		aimed_at = col
		col.aimed = true
	else:
		if aimed_at:
			aimed_at.aimed = false
