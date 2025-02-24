extends Area3D

@export var bt_player: BTPlayer

var target: Player
var blackboard: Blackboard
@onready var ray_cast: RayCast3D = $RayCast3D
@onready var timer: Timer = $Timer

var within_bounds_target: Player

func _ready() -> void:
	blackboard = bt_player.blackboard
	blackboard.bind_var_to_property("target_var", self, "target", true)
	body_entered.connect(_on_vision_area_body_entered)
	body_exited.connect(_on_vision_area_body_exited)
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_vision_area_body_entered(body: Node3D) -> void:
	if body is not Player: return
	within_bounds_target = body
	timer.start()

func _on_vision_area_body_exited(body: Node3D) -> void:
	if body is not Player: return
	within_bounds_target = null
	ray_cast.debug_shape_custom_color = Color(0, 255, 0)
	target = null

func _on_timer_timeout():
	if not within_bounds_target: return
	ray_cast.look_at(within_bounds_target.global_position + Vector3(0, 1, 0))
	ray_cast.force_raycast_update()
	
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider is Player:
			ray_cast.debug_shape_custom_color = Color(172, 0, 0)
			target = collider
		else:
			target = null
			ray_cast.debug_shape_custom_color = Color(0, 255, 0)
