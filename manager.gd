extends Node

const RANDOM_SEED := 0x60d07
const CPP_CLASS_NAMES: Array[StringName] = [
	&"CPPBenchmarkAlloc",
	&"CPPBenchmarkArray",
	&"CPPBenchmarkBinaryTrees",
	&"CPPBenchmarkControl",
	&"CPPBenchmarkForLoop",
	&"CPPBenchmarkHelloWorld",
	&"CPPBenchmarkLambdaPerformance",
	&"CPPBenchmarkMandelbrotSet",
	&"CPPBenchmarkMerkleTrees",
	&"CPPBenchmarkNbody",
	&"CPPBenchmarkSpectralNorm",
	&"CPPBenchmarkStringChecksum",
	&"CPPBenchmarkStringFormat",
	&"CPPBenchmarkStringManipulation",
]

class Results:
	var render_cpu := 0.0
	var render_gpu := 0.0
	var idle := 0.0
	var physics := 0.0
	var time := 0.0

class TestID:
	var name : String
	var category : String
	var language : String

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

	# Recognize paths in an exported project correctly.
	path = path.trim_suffix(".remap")

	# Check for runnable tests.
	for extension in languages.keys():
		if not path.ends_with(extension):
			continue

		var bench_script = load(path).new()
		for method in bench_script.get_method_list():
			if not method.name.begins_with(languages[extension]["test_prefix"]):
				continue

			# This method is a runnable test. Push it onto the result
			var test_id := TestID.new()
			test_id.name = method.name.trim_prefix(languages[extension]["test_prefix"])
			test_id.category = path.trim_prefix("res://benchmarks/").trim_suffix(extension)
			test_id.language = extension
			rv.push_back(test_id)

	return rv


# List of supported languages and their styles.
var languages := {".gd": {"test_prefix": "benchmark_"}, ".cpp": {"test_prefix": "benchmark_"}}

# List of benchmarks populated in `_ready()`.
var test_results := {}
var cpp_classes: Array[RefCounted] = []

var save_json_to_path := ""
var json_results_prefix := ""
var visualize := false


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


func _ready() -> void:
	RenderingServer.viewport_set_measure_render_time(get_tree().root.get_viewport_rid(),true)
	set_process(false)

	# Register script language compatibility
	if ClassDB.class_exists(&"CSharpScript"):
		languages[".cs"] = {"test_prefix": "Benchmark"}

	# Register contents of `benchmarks/` folder automatically.
	for benchmark_path in dir_contents("res://benchmarks/"):
		for test_id in test_ids_from_path(benchmark_path):
			test_results[test_id] = null

	# Load GDExtension (C++) benchmarks
	for cpp_class_name in CPP_CLASS_NAMES:
		if not ClassDB.class_exists(cpp_class_name):
			continue
		var cpp_class = ClassDB.instantiate(cpp_class_name)
		cpp_classes.append(cpp_class)
		for method in cpp_class.get_method_list():
			if not method.name.begins_with(languages[".cpp"]["test_prefix"]):
				continue
			var test_id := TestID.new()
			test_id.name = method.name.trim_prefix(languages[".cpp"]["test_prefix"])
			test_id.category = "C++/" + cpp_class.get_class().replace("CPPBenchmark", "")
			test_id.language = ".cpp"
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
		seed(RANDOM_SEED)
		await run_test(test_ids[i])
		print("Result: %s\n" % get_result_as_string(test_ids[i]))

	DisplayServer.window_set_title("[DONE] %d benchmarks - Godot Benchmarks" % test_ids.size())
	print_rich("[color=green][b]Done running %d benchmarks.[/b] Results JSON:[/color]\n" % test_ids.size())

	print("Results JSON:")
	print("----------------")
	print(JSON.stringify(get_results_dict(json_results_prefix)))
	print("----------------")

	if not save_json_to_path.is_empty():
		print("Saving JSON output to: %s" % save_json_to_path)
		print("Using prefix for results: %s" % json_results_prefix)
		var file := FileAccess.open(save_json_to_path, FileAccess.WRITE)
		file.store_string(JSON.stringify(get_results_dict(json_results_prefix)))

	if return_path:
		get_tree().change_scene_to_file(return_path)
	else:
		# FIXME: The line below crashes the engine. Commenting it results in a
		# "ObjectDB instances leaked at exit" warning (but no crash).
		#get_tree().queue_delete(get_tree())
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

	var language := test_id.language
	var bench_script
	if language != ".cpp":
		bench_script = load("res://benchmarks/%s%s" % [test_id.category, language]).new()
	else:
		var cpp_class_name := "CPPBenchmark" + test_id.category.replace("C++", "").replace("/", "")
		for cpp_class in cpp_classes:
			if cpp_class_name == cpp_class.get_class():
				bench_script = ClassDB.instantiate(cpp_class_name)
				break
	if not is_instance_valid(bench_script):
		printerr("Benchmark not found!")
		return
	var results := Results.new()

	# Call and time the function to be tested
	var begin_time := Time.get_ticks_usec()
	# Redundant awaits don't seem to cause a performance variation.
	var bench_node = await bench_script.call(languages[test_id.language]["test_prefix"] + test_id.name)
	results.time = (Time.get_ticks_usec() - begin_time) * 0.001

	# Continue benchmarking if the function call has returned a node
	var frames_captured := 0
	if bench_node:
		get_tree().current_scene.add_child(bench_node)

		# TODO: Any better ways of waiting for shader compilation?
		for i in 3:
			await get_tree().process_frame

		var time_limit: int = bench_script.get("benchmark_time")
		begin_time = Time.get_ticks_usec()

		while (Time.get_ticks_usec() - begin_time) < time_limit:
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
		if bench_script.get("test_" + metric.name) == false: # account for null
			results.set(metric.name, 0.0)

	test_results[test_id] = results

func get_result_as_string(test_id: TestID) -> String:
	# Returns all non-zero metrics formatted as a string
	var rd := get_test_result_as_dict(test_id)

	for key in rd.keys():
		if rd[key] == 0.0:
			rd.erase(key)

	return JSON.stringify(rd)

func get_test_result_as_dict(test_id: TestID, results_prefix: String = "") -> Dictionary:
	var result : Results = test_results[test_id]
	var rv := {}
	if not results_prefix.is_empty():
		# Nest the results dictionary with a prefix for easier merging of multiple unrelated runs with `jq`.
		# For example, this is used on the benchmarks server to merge runs on several GPU vendors into a single JSON file.
		rv = { results_prefix: {} }
	if not result:
		return rv

	for metric in result.get_property_list():
		if metric.type == TYPE_FLOAT:
			var m : float = result.get(metric.name)
			const sig_figs = 4
			if not is_zero_approx(m):
				# Only store metrics if not 0 to reduce JSON size.
				if not results_prefix.is_empty():
					rv[results_prefix][metric.name] = snapped(m, pow(10,floor(log(m)/log(10))-sig_figs+1))
				else:
					rv[metric.name] = snapped(m, pow(10,floor(log(m)/log(10))-sig_figs+1))

	return rv

func get_results_dict(results_prefix: String = "") -> Dictionary:
	var version_info := Engine.get_version_info()
	var version_string: String
	if version_info.patch >= 1:
		version_string = "v%d.%d.%d.%s.%s" % [version_info.major, version_info.minor, version_info.patch, version_info.status, version_info.build]
	else:
		version_string = "v%d.%d.%s.%s" % [version_info.major, version_info.minor, version_info.status, version_info.build]

	# Only list information that doesn't change across benchmark runs on different GPUs,
	# as JSON files are merged together. Otherwise, the fields would overwrite each other
	# with different information.

	# Benchmark binaries are compiled with GCC (which matches official binaries),
	# so we check for the GCC version.
	# TODO: Write the name/version of the actual compiler that was used to compile the binary
	# by inserting this information at compile-time (see GH-98845).
	var output := []
	var execute_gcc := OS.execute("gcc", ["--version"], output)
	var compiler := ""
	if execute_gcc == OK and output.size() >= 1:
		compiler = output[0].split("\n")[0]
	else:
		push_warning("Can't detect C/C++ compiler version. Make sure `gcc` is installed and in `PATH`.")

	# Benchmark binaries are linked with GNU ld (which matches official binaries),
	# so we check for the ld version.
	# TODO: Write the name/version of the actual linker that was used to link the binary
	# by inserting this information at compile-time (see GH-98845).
	output = []
	var execute_ld := OS.execute("ld", ["--version"], output)
	var linker := ""
	if execute_ld == OK and output.size() >= 1:
		linker = output[0].split("\n")[0]
	else:
		push_warning("Can't detect C/C++ linker
		 version. Make sure `ld` is installed and in `PATH`.")

	var dict := {
		engine = {
			version = version_string,
			version_hash = version_info.hash,
		},
		system = {
			os = "%s %s" % [OS.get_distribution_name(), OS.get_version_alias()],
			compiler = compiler,
			linker = linker,
			cpu_name = OS.get_processor_name(),
			cpu_architecture = (
				"x86_64" if OS.has_feature("x86_64")
				else "arm64" if OS.has_feature("arm64")
				else "arm" if OS.has_feature("arm")
				else "x86" if OS.has_feature("x86")
				else "unknown"
			),
			cpu_count = OS.get_processor_count(),
		}
	}

	var benchmarks := []
	for test_id in get_test_ids():
		var result_dict := get_test_result_as_dict(test_id, results_prefix)
		# Only write a dictionary if a benchmark was run for it.
		var should_write_dict := false
		if results_prefix.is_empty():
			should_write_dict = not result_dict.is_empty()
		else:
			should_write_dict = not result_dict[results_prefix].is_empty()

		if should_write_dict:
			benchmarks.push_back({
				category = test_id.pretty_category(),
				name = test_id.pretty_name(),
				results = result_dict,
			})

	dict.benchmarks = benchmarks

	return dict
