class_name SpeedIndicator
extends TextureRect

var mat = material as ShaderMaterial

func speed_up():
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/hole_radius", .34, .1)
	#mat.set_shader_parameter("hole_radius", .34)
	
func slow_down():
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/hole_radius", 1.0, .1)
	#mat.set_shader_parameter("hole_radius", 1.0)
