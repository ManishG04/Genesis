class_name AbilityIndicator
extends TextureRect

var original_position: Vector2

func _ready() -> void:
	original_position = position

func select_ability(type: Util.ABILITIES):
	var atlas_texture = texture as AtlasTexture
	atlas_texture.region.position.x = (2 + type) * 64
	vibrate()

func disable():
	var atlas_texture = texture as AtlasTexture

func vibrate(duration: float = 0.2, intensity: float = 5.0):
	start_vibration()
	await get_tree().create_timer(.2).timeout
	stop_vibration()
	#if not original_position: return
	#var tween = create_tween()
#
	#for i in range(5):  # Number of shakes
		#var offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		#tween.tween_property(self, "position", original_position + offset, duration / 10)
		#tween.tween_property(self, "position", original_position, duration / 10)

var _is_vibrating = false
func start_vibration():
	if _is_vibrating: return
	_is_vibrating = true
	var mat = material as ShaderMaterial
	mat.set_shader_parameter("enable_vibration", true)

func stop_vibration():
	_is_vibrating = false
	var mat = material as ShaderMaterial
	mat.set_shader_parameter("enable_vibration", false)
