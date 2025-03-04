extends Node

@export var abilities: Array[Util.ABILITIES] = []
@export var selected_ability: int = 0:
	set(new):
		selected_ability = new % len(abilities)
		if ability_indicator:
			ability_indicator.select_ability(abilities[selected_ability])
#		Reset time scale
		if abilities[selected_ability] != Util.ABILITIES.TIME_STOPPER:
			Engine.time_scale = 1.0
		if ability_label:
			match abilities[selected_ability]:
				Util.ABILITIES.GRAB:
					ability_label.text = "GRAB"
				Util.ABILITIES.SWAP:
					ability_label.text = "SWAP"
				Util.ABILITIES.PROJECTILE_THROWER:
					ability_label.text = "PROJECTILE"
				Util.ABILITIES.TIME_STOPPER:
					ability_label.text = "TIME STOP"

@onready var grabber: Grabber = $Grabber
@onready var position_swapper: PositionSwapper = $PositionSwapper
@onready var projectile_thrower: ProjectileThrower = $ProjectileThrower
@onready var time_stopper: TimeStopper = $TimeStopper

@onready var ability_label: Label = %AbilityLabel
@onready var ability_indicator: AbilityIndicator = %AbilityIndicator

func _ready() -> void:
	selected_ability %= len(abilities)
	ability_indicator.disable()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_weapon"):
		selected_ability += 1
	if event.is_action_pressed("prev_weapon"):
		selected_ability -= 1
	for i in 5:
		if event.is_action_pressed("ability_%s" % (i + 1)):
			selected_ability = i

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
		Util.ABILITIES.TIME_STOPPER:
			time_stopper.handle_ability()
