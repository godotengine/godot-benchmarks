extends Label
class_name Benchmark

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@export var test_render_cpu : = false
@export var test_render_gpu : = false
@export var test_idle : = false
@export var test_physics : = false
@export var time_limit := true

# Called when the node enters the scene tree for the first time.
func _process(delta):
	var txt = ""
	if (test_render_cpu):
		txt+=str("CPU: ",RenderingServer.viewport_get_measured_render_time_cpu(get_tree().root.get_viewport_rid()) + RenderingServer.get_frame_setup_time_cpu(),"\n")
	if (test_render_gpu):
		txt+=str("GPU: ",RenderingServer.viewport_get_measured_render_time_gpu(get_tree().root.get_viewport_rid()) ,"\n")
	text = txt

func _ready():
	add_to_group("bechnmark_config")
	if (Manager.is_recording()):
		set_process(false)
		hide()
	add_theme_color_override("font_color",Color(1,1,1))
	add_theme_color_override("font_color_shadow",Color(0,0,0))
	add_theme_constant_override("outline_size",2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
