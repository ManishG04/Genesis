@tool
class_name LightController
extends Node3D

@export var light_node: OmniLight3D

@export_category("Flickering")
@export var flickering_enabled: bool = true
@export_range(0, 50, 0.5) var light_range: float = 5.0:
	set(new):
		light_range = new
		light_node.omni_range = light_range

@export_range(0, 10, 0.05) var max_light_energy: float = 2.0
@export_range(0, 10, 0.05) var min_light_energy: float = 0.6

@export_range(0, 10, 0.05) var max_delay: float = 1.0
@export_range(0, 10, 0.05) var min_delay: float = 0.05

@export_range(0, 1, 0.01) var interval: float = 0.05
@export_range(0, 10, 1) var max_flicker_num: int = 3
@export_range(0, 10, 1) var min_flicker_num: int = 1

var rng := RandomNumberGenerator.new()
var timer: SceneTreeTimer

func _ready() -> void:
	rng.randomize()
	if not light_node:
		if $OmniLight3D:
			light_node = $OmniLight3D
	assert(light_node, "No Light Node Selected for controller: " + name)
	flicker()

func flicker():
	var rtime = rng.randf_range(min_delay, max_delay)
	var rnum = rng.randi_range(min_flicker_num, max_flicker_num)
	var tween = create_tween()
	for i in rnum:
		tween.tween_property(light_node, "light_energy", min_light_energy, interval)
		tween.tween_property(light_node, "light_energy", max_light_energy, interval)
	tween.tween_interval(rtime)
	tween.tween_callback(flicker)
	#flicker()
