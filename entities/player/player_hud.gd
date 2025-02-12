extends Control

@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(player, "Player not selected in hud")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
