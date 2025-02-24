class_name GroundedEnemy
extends GroundedNPC

func _ready() -> void:
	#attack_area.body_entered.connect(_on_attack_area_body_entered)
	#attack_area.body_exited.connect(_on_attack_area_body_exited)
	pass
		
func attack():
	locked_animations = true
	animated_sprite.play("attack")
	await animated_sprite.animation_finished
	locked_animations = false

func _on_attack_area_body_entered(body: Node3D) -> void:
	if body is not Player: return
	#attack()

func _on_attack_area_body_exited(body: Node3D) -> void:
	if body is not Player: return
