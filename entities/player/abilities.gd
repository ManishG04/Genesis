extends Node

@export var abilities: Array[Util.ABILITIES] = []
@export var selected_ability: int = 0:
	set(new):
		print(new)
		selected_ability = new % len(abilities)
		if ability_label:
			match abilities[selected_ability]:
				Util.ABILITIES.GRAB:
					ability_label.text = "GRAB"
				Util.ABILITIES.SWAP:
					ability_label.text = "SWAP"
				Util.ABILITIES.PROJECTILE_THROWER:
					ability_label.text = "PROJECTILE"

@onready var grabber: Grabber = $Grabber
@onready var position_swapper: PositionSwapper = $PositionSwapper
@onready var projectile_thrower: ProjectileThrower = $ProjectileThrower
@onready var ability_label: Label = %AbilityLabel

func _ready() -> void:
	selected_ability %= len(abilities)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("next_weapon"):
		selected_ability += 1
	if Input.is_action_just_pressed("prev_weapon"):
		selected_ability -= 1

func _physics_process(delta: float) -> void:
	if len(abilities) <= 0:
		return
	match abilities[selected_ability]:
		Util.ABILITIES.GRAB:
			grabber.handle_ability()
		Util.ABILITIES.SWAP:
			position_swapper.handle_ability()
		Util.ABILITIES.PROJECTILE_THROWER:
			projectile_thrower.handle_ability()
