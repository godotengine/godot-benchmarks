extends Label
class_name Benchmark

@export var test_render_cpu : = false
@export var test_render_gpu : = false
@export var test_idle : = false
@export var test_physics : = false
@export var time_limit := true


func _ready() -> void:
	add_to_group("benchmark_config")
	if Manager.recording:
		set_process(false)
		hide()
	add_theme_color_override("font_color", Color(1, 1, 1))
	add_theme_color_override("font_outline_color", Color(0, 0, 0))
	add_theme_constant_override("outline_size", 8)
	# Position away from the screen edges for better readability.
	position = Vector2(20, 20)


func _process(_delta: float) -> void:
	var txt: String = ""
	if test_render_cpu:
		txt += "CPU: %s ms (incl. %s ms frame setup time)\n" % [
			str(RenderingServer.viewport_get_measured_render_time_cpu(get_tree().root.get_viewport_rid()) + RenderingServer.get_frame_setup_time_cpu()).pad_decimals(2),
			str(RenderingServer.get_frame_setup_time_cpu()).pad_decimals(2),
		]
	if test_render_gpu:
		txt += "GPU: %s ms\n" % str(RenderingServer.viewport_get_measured_render_time_gpu(get_tree().root.get_viewport_rid())).pad_decimals(2)
	text = txt
