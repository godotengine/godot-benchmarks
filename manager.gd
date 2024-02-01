extends Node

class Results:
	var render_cpu := 0.0
	var render_gpu := 0.0
	var idle := 0.0
	var physics := 0.0
	var time := 0.0

class TestID:
	var name : String
	var category : String

	func pretty_name() -> String:
		return name.capitalize()
	func pretty_category() -> String:
		return category.replace("/", " > ").capitalize()
	func pretty() -> String:
		return "%s: %s" % [pretty_category(), pretty_name()]

	func _to_string() -> String:
		return "%s/%s" % [category, name]


func test_ids_from_path(path: String) -> Array[TestID]:
	var rv : Array[TestID] = []
	if not path.ends_with(".gd"):
		return rv

	var script = load(path).new()
	if not (script is Benchmark):
		return rv

	var bench_script : Benchmark = script
	for method in bench_script.get_method_list():
		if not method.name.begins_with("benchmark_"):
			continue

		var test_id := TestID.new()
		test_id.name = method.name.trim_prefix("benchmark_")
		test_id.category = path.trim_prefix("res://benchmarks/").trim_suffix(".gd")
		rv.push_back(test_id)
	return rv


# List of benchmarks populated in `_ready()`.
var test_results := {}

var save_json_to_path := ""


## Recursively walks the given directory and returns all files found
func dir_contents(path: String, contents: PackedStringArray = PackedStringArray()) -> PackedStringArray:

	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				dir_contents(path.path_join(file_name), contents)
			else:
				contents.push_back(path.path_join(file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path: %s" % path)

	return contents


func _ready():
	RenderingServer.viewport_set_measure_render_time(get_tree().root.get_viewport_rid(),true)
	set_process(false)

	# Register contents of `benchmarks/` folder automatically.
	for benchmark_path in dir_contents("res://benchmarks/"):
		for test_id in test_ids_from_path(benchmark_path):
			test_results[test_id] = null


func get_test_ids() -> Array[TestID]:
	var rv : Array[TestID] = []
	rv.assign(test_results.keys().duplicate())
	var sorter = func(a, b):
		return a.to_string() < b.to_string()
	rv.sort_custom(sorter)
	return rv


func benchmark(test_ids: Array[TestID], return_path: String) -> void:
	await get_tree().process_frame

	for i in range(test_ids.size()):
		DisplayServer.window_set_title("%d/%d - Running %s" % [i + 1, test_ids.size(), test_ids[i].pretty()])
		print("Running benchmark %d of %d: %s" % [i + 1, test_ids.size(), test_ids[i]])
		await run_test(test_ids[i])

	DisplayServer.window_set_title("[DONE] %d benchmarks - Godot Benchmarks" % test_ids.size())
	print_rich("[color=green][b]Done running %d benchmarks.[/b] Results JSON:[/color]\n" % test_ids.size())

	print("Results JSON:")
	print("----------------")
	print(JSON.stringify(get_results_dict()))
	print("----------------")

	if not save_json_to_path.is_empty():
		print("Saving JSON output to: %s" % save_json_to_path)
		var file := FileAccess.open(save_json_to_path, FileAccess.WRITE)
		file.store_string(JSON.stringify(get_results_dict()))

	if return_path:
		get_tree().change_scene_to_file(return_path)
	else:
		get_tree().quit()


func run_test(test_id: TestID) -> void:
	set_process(true)

	var new_scene := PackedScene.new()
	new_scene.pack(Node.new())
	get_tree().change_scene_to_packed(new_scene)

	# Wait for the scene tree to be ready
	while not (get_tree().current_scene and get_tree().current_scene.get_child_count() == 0):
		#print("Waiting for scene change...")
		await get_tree().process_frame
	# Add a dummy child so that the above check works for subsequent reloads
	get_tree().current_scene.add_child(Node.new())

	var benchmark_script : Benchmark = load("res://benchmarks/%s.gd" % test_id.category).new()

	var results := Results.new()
	var begin_time := Time.get_ticks_usec()
	var bench_node = benchmark_script.call("benchmark_" + test_id.name)
	results.time = (Time.get_ticks_usec() - begin_time) * 0.001

	var frames_captured := 0
	if bench_node:
		get_tree().current_scene.add_child(bench_node)

		# TODO: Any better ways of waiting for shader compilation?
		for i in 3:
			await get_tree().process_frame

		begin_time = Time.get_ticks_usec()

		# Time limit of 5 seconds (5 million microseconds).
		while (Time.get_ticks_usec() - begin_time) < 5e6:
			await get_tree().process_frame

			results.render_cpu += RenderingServer.viewport_get_measured_render_time_cpu(get_tree().root.get_viewport_rid())  + RenderingServer.get_frame_setup_time_cpu()
			results.render_gpu += RenderingServer.viewport_get_measured_render_time_gpu(get_tree().root.get_viewport_rid())
			# Godot updates idle and physics performance monitors only once per second,
			# with the value representing the average time spent processing idle/physics process in the last second.
			# The value is in seconds, not milliseconds.
			# Keep the highest reported value throughout the run.
			results.idle = maxf(results.idle, Performance.get_monitor(Performance.TIME_PROCESS) * 1000)
			results.physics = maxf(results.physics, Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000)

			frames_captured += 1

	results.render_cpu /= float(max(1.0, float(frames_captured)))
	results.render_gpu /= float(max(1.0, float(frames_captured)))
	# Don't divide `results.idle` and `results.physics` since these are already
	# metrics calculated on a per-second basis.

	for metric in results.get_property_list():
		if benchmark_script.get("test_" + metric.name) == false: # account for null
			results.set(metric.name, 0.0)

	test_results[test_id] = results

func get_test_result_as_dict(test_id: TestID) -> Dictionary:
	var result : Results = test_results[test_id]
	var rv := {}
	if not result:
		return rv

	for metric in result.get_property_list():
		if metric.type == TYPE_FLOAT:
			var m : float = result.get(metric.name)
			const sig_figs = 4
			rv[metric.name] = snapped(m, pow(10,floor(log(m)/log(10))-sig_figs+1))

	return rv

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
	for test_id in get_test_ids():
		benchmarks.push_back({
			category = test_id.pretty_category(),
			name = test_id.pretty_name(),
			results = get_test_result_as_dict(test_id),
		})

	dict.benchmarks = benchmarks

	return dict
