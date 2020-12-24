extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class Results:
	var render_cpu := 0.0
	var render_gpu := 0.0
	var idle := 0.0
	var physics := 0.0

var frames_captured := 0

class Test:
	var name : String
	var category : String
	var path : String
	var results : Results = null
	func _init(p_name : String,p_category: String,p_path : String):
		name = p_name
		category = p_category
		path = p_path
		
var results : Results = null

var tests=[
	Test.new("Static Cull","Culling","res://rendering/culling/basic_cull.tscn"),
	Test.new("Dynamic Cull","Culling","res://rendering/culling/dynamic_cull.tscn"),
	Test.new("Static Lights Cull","Culling","res://rendering/culling/static_light_cull.tscn"),
	Test.new("Dynamic Lights Cull","Culling","res://rendering/culling/dynamic_light_cull.tscn"),
	Test.new("Directional Light Cull","Culling","res://rendering/culling/directional_light_cull.tscn"),
]

var recording := false
var remaining_time := 5.0

func is_recording():
	return recording
	
func get_test_count() -> int:
	return tests.size()	

func get_test_name(idx) -> String:
	return tests[idx].name

func get_test_category(idx) -> String:
	return tests[idx].category

func get_test_result(idx) -> Results:
	return tests[idx].results

var tests_queue = []
var test_time := 5.0
var return_to_scene : = ""
var skip_first := false

func benchmark(queue : Array,time : float,return_path : String):
	tests_queue = queue
	if (tests_queue.size() == 0):
		return
	test_time = time
	return_to_scene = return_path
	begin_test()

var record_render_gpu := false
var record_render_cpu := false
var record_idle := false
var record_physics := false

func begin_test():	
	results = Results.new()
	recording = true
	results = Results.new()
	remaining_time = test_time
	set_process(true)
	get_tree().change_scene(tests[tests_queue[0]].path)
	var bmgroup = get_tree().get_nodes_in_group("bechnmark_config")
	if (bmgroup.size()):
		var bm = bmgroup[0]
		record_render_cpu = bm.test_render_cpu
		record_render_gpu = bm.test_render_gpu
		record_idle = bm.test_idle
		record_physics = bm.test_physics
	else:
		record_render_cpu = true
		record_render_gpu = true
		record_idle = true
		record_physics = true
		
	skip_first = true
	frames_captured = 0
	
	
func end_test():
	recording = false
	results.render_cpu /= float(frames_captured)
	results.render_gpu /= float(frames_captured)
	results.idle /= float(frames_captured)
	results.physics /= float(frames_captured)
		
	tests[tests_queue[0]].results = results
	results = null
	tests_queue.pop_front()
	if (tests_queue.size() > 0):
		begin_test() #tests pending? goto next
	else:
		get_tree().change_scene(return_to_scene)
		return_to_scene=""
		
	
func _process(delta):
	if (not recording):
		return 
	if (skip_first):
		skip_first=false
		return

	if (record_render_cpu):
		results.render_cpu += RenderingServer.viewport_get_measured_render_time_cpu(get_tree().root.get_viewport_rid())  + RenderingServer.get_frame_setup_time_cpu()
	if (record_render_gpu):
		results.render_gpu += RenderingServer.viewport_get_measured_render_time_gpu(get_tree().root.get_viewport_rid())
	if (record_idle):
		results.idle += 0.0
	if (record_physics):
		results.physics += 0.0
	frames_captured += 1
	remaining_time -= delta
	if (remaining_time < 0.0):
		end_test()		
	
func report_time(delta,render_cpu,render_gpu,idle_cpu,physics_cpu):
	if (not recording):
		return		

# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.viewport_set_measure_render_time(get_tree().root.get_viewport_rid(),true)
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
