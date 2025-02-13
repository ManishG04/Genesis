class_name InteractableArea
extends Area3D

signal interacted

@export var tooltip_label: Label3D
@export var enabled: bool = true:
	set(new):
		enabled = new
		if not new:
			disable()

var player_inside: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if not enabled: 
		disable()
		return
	if not tooltip_label and $TooltipLabel:
		tooltip_label = $TooltipLabel

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_inside:
		emit_signal("interacted")

func disable():
	body_entered.disconnect(_on_body_entered)
	body_exited.disconnect(_on_body_exited)
	player_inside = false

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		tooltip_label.show()
		player_inside = true


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		tooltip_label.hide()
		player_inside = false
