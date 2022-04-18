extends Node

class Results:
	var render_cpu := 0.0
	var render_gpu := 0.0
	var idle := 0.0
	var physics := 0.0
	var time := 0.0

class Test:
	var name : String
	var category : String
	var path : String
	var results : Results = null
	func _init(p_name : String,p_category: String,p_path : String):
		name = p_name
		category = p_category
		path = p_path

var tests := [
	Test.new("Static Cull", "Culling", "res://rendering/culling/basic_cull.tscn"),
	Test.new("Dynamic Cull", "Culling", "res://rendering/culling/dynamic_cull.tscn"),
	Test.new("Static Lights Cull", "Culling", "res://rendering/culling/static_light_cull.tscn"),
	Test.new("Dynamic Lights Cull", "Culling", "res://rendering/culling/dynamic_light_cull.tscn"),
	Test.new("Directional Light Cull", "Culling", "res://rendering/culling/directional_light_cull.tscn"),

	Test.new("Untyped Int Array", "GDScript", "res://gdscript/untyped_int_array.tscn"),
	Test.new("Typed Int Array", "GDScript", "res://gdscript/typed_int_array.tscn"),
	Test.new("Untyped String Array", "GDScript", "res://gdscript/untyped_string_array.tscn"),
	Test.new("Typed String Array", "GDScript", "res://gdscript/typed_string_array.tscn"),
	Test.new("Packed String Array", "GDScript", "res://gdscript/packed_string_array.tscn"),
]

var frames_captured := 0
var results: Results = null
var recording := false
var begin_time := 0.0
var remaining_time := 5.0
var tests_queue = []
## Used to display the number of benchmarks that need to be run in the console output and window title.
var tests_queue_initial_size := 0
var test_time := 5.0
var return_to_scene : = ""
var skip_first := false

var record_render_gpu := false
var record_render_cpu := false
var record_idle := false
var record_physics := false
var time_limit := true


func _ready():
	RenderingServer.viewport_set_measure_render_time(get_tree().root.get_viewport_rid(),true)
	set_process(false)


func _process(delta: float) -> void:
	if not recording:
		return
		
	if skip_first:
		skip_first = false
		return

	if record_render_cpu:
		results.render_cpu += RenderingServer.viewport_get_measured_render_time_cpu(get_tree().root.get_viewport_rid())  + RenderingServer.get_frame_setup_time_cpu()
	if record_render_gpu:
		results.render_gpu += RenderingServer.viewport_get_measured_render_time_gpu(get_tree().root.get_viewport_rid())
	if record_idle:
		results.idle += 0.0
	if record_physics:
		results.physics += 0.0

	frames_captured += 1

	if time_limit:
		# Some benchmarks (such as scripting) may not have a time limit.
		remaining_time -= delta
		if remaining_time < 0.0:
			end_test()


func get_test_count() -> int:
	return tests.size()


func get_test_name(index: int) -> String:
	return tests[index].name


func get_test_category(index: int) -> String:
	return tests[index].category


func get_test_result(index: int) -> Results:
	return tests[index].results


func benchmark(queue: Array, time: float, return_path: String) -> void:
	tests_queue = queue
	if tests_queue.size() == 0:
		return

	if tests_queue_initial_size == 0:
		tests_queue_initial_size = queue.size()

	test_time = time
	return_to_scene = return_path
	begin_test()


func begin_test() -> void:
	DisplayServer.window_set_title("%d/%d - Running - Godot Benchmarks" % [tests_queue_initial_size - tests_queue.size() + 1, tests_queue_initial_size])
	print("Running benchmark %d of %d..." % [tests_queue_initial_size - tests_queue.size() + 1, tests_queue_initial_size])
	
	results = Results.new()
	recording = true
	results = Results.new()
	begin_time = Time.get_ticks_usec() * 0.001
	remaining_time = test_time
	set_process(true)
	get_tree().change_scene(tests[tests_queue[0]].path)
	
	var benchmark_group := get_tree().get_nodes_in_group("benchmark_config")
	
	if benchmark_group.size() >= 1:
		var benchmark: Node = benchmark_group[0]
		record_render_cpu = benchmark.test_render_cpu
		record_render_gpu = benchmark.test_render_gpu
		record_idle = benchmark.test_idle
		record_physics = benchmark.test_physics
		time_limit = benchmark.time_limit
	else:
		record_render_cpu = true
		record_render_gpu = true
		record_idle = true
		record_physics = true
		time_limit = true

	skip_first = true
	frames_captured = 0


func end_test() -> void:
	recording = false
	results.render_cpu /= float(max(1.0, float(frames_captured)))
	results.render_gpu /= float(max(1.0, float(frames_captured)))
	results.idle /= float(max(1.0, float(frames_captured)))
	results.physics /= float(max(1.0, float(frames_captured)))
	results.time = Time.get_ticks_usec() * 0.001 - begin_time

	tests[tests_queue[0]].results = results
	results = null
	tests_queue.pop_front()
	
	# If more tests are still pending, go to the next test.
	if tests_queue.size() > 0:
		begin_test()
	else:
		get_tree().change_scene(return_to_scene)
		return_to_scene = ""
		DisplayServer.window_set_title("[DONE] %d benchmarks - Godot Benchmarks" % tests_queue_initial_size)
		print("Done running %d benchmarks. Results JSON:\n" % tests_queue_initial_size)
		print(get_results_dict())


func get_results_dict() -> Dictionary:
	var version_info := Engine.get_version_info()
	var version_string: String
	if version_info.patch >= 1:
		version_string = "v%d.%d.%d.%s.%s" % [version_info.major, version_info.minor, version_info.patch, version_info.status, version_info.build]
	else:
		version_string = "v%d.%d.%s.%s" % [version_info.major, version_info.minor, version_info.status, version_info.build]
		
	var dict := {
		engine = {
			version = version_string,
			version_hash = version_info.hash,
			build_type = "debug" if OS.is_debug_build() else "release",
		},
		system = {
			cpu_architecture = (
				"x86_64" if OS.has_feature("x86_64")
				else "arm64" if OS.has_feature("arm64")
				else "arm" if OS.has_feature("arm")
				else "x86" if OS.has_feature("x86")
				else "unknown"
			),
			cpu_count = OS.get_processor_count(),
			gpu_name = RenderingServer.get_video_adapter_name(),
			gpu_vendor = RenderingServer.get_video_adapter_vendor(),
		}
	}
	
	var benchmarks := []
	for i in Manager.get_test_count():
		var test := {
			category = Manager.get_test_category(i),
			name = Manager.get_test_name(i),
		}
		
		var result: Manager.Results = Manager.get_test_result(i)
		if result:
			test.results = {
				render_cpu = snapped(result.render_cpu, 0.01),
				render_gpu = snapped(result.render_gpu, 0.01),
				idle = snapped(result.idle, 0.01),
				physics = snapped(result.physics, 0.01),
				time = round(result.time),
			}
		else:
			test.results = {}
			
		benchmarks.push_back(test)
	
	dict.benchmarks = benchmarks
	
	return dict
