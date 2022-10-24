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

# List of benchmarks populated in `_ready()`.
var tests: Array[Test] = []

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
var run_from_cli := false
var save_json_to_path := ""

var record_render_gpu := false
var record_render_cpu := false
var record_idle := false
var record_physics := false
var time_limit := true


## Returns file paths ending with `.tscn` within a folder, recursively.
func dir_contents(path: String, contents: PackedStringArray = PackedStringArray()) -> PackedStringArray:

	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				dir_contents(path.path_join(file_name), contents)
			elif file_name.ends_with(".tscn"):
				contents.push_back(path.path_join(file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path: %s" % path)

	return contents


func _ready():
	RenderingServer.viewport_set_measure_render_time(get_tree().root.get_viewport_rid(),true)
	set_process(false)

	# Register benchmarks automatically based on `.tscn` file paths in the `benchmarks/` folder.
	# Scene names starting with `_` are excluded, as this denotes an instanced scene that is
	# referred to in another scene.
	var benchmark_paths := dir_contents("res://benchmarks/")
	benchmark_paths.sort()
	for benchmark_path in benchmark_paths:
		var benchmark_name := benchmark_path.get_file().get_basename()
		# Capitalize only after checking whether the name begins with `_`, as `capitalize()`
		# removes underscores.
		if not benchmark_name.begins_with("_"):
			benchmark_name = benchmark_name.capitalize()
			var category := benchmark_path.get_base_dir().trim_prefix("res://benchmarks/").replace("/", " > ").capitalize()
			tests.push_back(Test.new(benchmark_name, category, benchmark_path))


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


func get_test_path(index: int) -> String:
	return tests[index].path


func benchmark(queue: Array, return_path: String) -> void:
	tests_queue = queue
	if tests_queue.size() == 0:
		return

	if tests_queue_initial_size == 0:
		tests_queue_initial_size = queue.size()

	# Run benchmarks for 5 seconds if they have a time limit.
	test_time = 5.0
	return_to_scene = return_path
	begin_test()


func begin_test() -> void:
	DisplayServer.window_set_title("%d/%d - Running - Godot Benchmarks" % [tests_queue_initial_size - tests_queue.size() + 1, tests_queue_initial_size])
	print("Running benchmark %d of %d: %s" % [
			tests_queue_initial_size - tests_queue.size() + 1,
			tests_queue_initial_size,
			tests[tests_queue[0]].path.trim_prefix("res://benchmarks/").trim_suffix(".tscn")]
	)

	results = Results.new()
	set_process(true)
	get_tree().change_scene_to_file(tests[tests_queue[0]].path)

	recording = true
	begin_time = Time.get_ticks_usec() * 0.001
	remaining_time = test_time

	# Wait for the scene tree to be ready (required for `benchmark_config` group to be available).
	# This requires waiting for 2 frames to work consistently (1 frame is flaky).
	for i in 2:
		await get_tree().process_frame

	var benchmark_node := get_tree().get_first_node_in_group("benchmark_config")

	if benchmark_node:
		record_render_cpu = benchmark_node.test_render_cpu
		record_render_gpu = benchmark_node.test_render_gpu
		record_idle = benchmark_node.test_idle
		record_physics = benchmark_node.test_physics
		time_limit = benchmark_node.time_limit
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
		get_tree().change_scene_to_file(return_to_scene)
		return_to_scene = ""
		DisplayServer.window_set_title("[DONE] %d benchmarks - Godot Benchmarks" % tests_queue_initial_size)
		print_rich("[color=green][b]Done running %d benchmarks.[/b] Results JSON:[/color]\n" % tests_queue_initial_size)

		print("Results JSON:")
		print("----------------")
		print(JSON.stringify(get_results_dict()))
		print("----------------")

		if not save_json_to_path.is_empty():
			print("Saving JSON output to: %s" % save_json_to_path)
			var file := FileAccess.open(save_json_to_path, FileAccess.WRITE)
			file.store_string(JSON.stringify(get_results_dict()))

		if run_from_cli:
			# Automatically exit after running benchmarks for automation purposes.
			get_tree().quit()


func get_results_dict() -> Dictionary:
	var version_info := Engine.get_version_info()
	var version_string: String
	if version_info.patch >= 1:
		version_string = "v%d.%d.%d.%s.%s" % [version_info.major, version_info.minor, version_info.patch, version_info.status, version_info.build]
	else:
		version_string = "v%d.%d.%s.%s" % [version_info.major, version_info.minor, version_info.status, version_info.build]

	var engine_binary := FileAccess.open(OS.get_executable_path(), FileAccess.READ)
	var dict := {
		engine = {
			version = version_string,
			version_hash = version_info.hash,
			build_type = (
					"editor" if OS.has_feature("editor")
					else "template_debug" if OS.is_debug_build()
					else "template_release"
			),
			binary_size = engine_binary.get_length(),
		},
		system = {
			os = OS.get_name(),
			cpu_name = OS.get_processor_name(),
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

		var result: Results = Manager.get_test_result(i)
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
