extends Node
@onready var grabber: Grabber = $Grabber
@onready var position_swapper: PositionSwapper = $PositionSwapper

func _physics_process(delta: float) -> void:
	grabber.handle_grabber()
	position_swapper.handle_swapper()
