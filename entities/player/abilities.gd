extends Node

@export var abilities: Array[Util.ABILITIES] = []
@export var selected_ability: int = 0:
	set(new):
		selected_ability = abs(new) % len(abilities)
		print(selected_ability)

@onready var grabber: Grabber = $Grabber
@onready var position_swapper: PositionSwapper = $PositionSwapper

func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.is_pressed():
	if event.is_action_pressed("next_weapon"):
		selected_ability += 1
		print("SDLKFJ")
	if event.is_action_pressed("prev_weapon"):
		selected_ability -= 1

func _ready() -> void:
	selected_ability %= len(abilities)

func _physics_process(delta: float) -> void:
	if len(abilities) <= 0:
		return
	match abilities[selected_ability]:
		Util.ABILITIES.GRAB:
			grabber.handle_ability()
		Util.ABILITIES.SWAP:
			position_swapper.handle_ability()
