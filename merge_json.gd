# Usage: godot -s merge_json.gd -- json1.md json2.md [...] --output-path output.md
extends SceneTree

func _init() -> void:
	if OS.get_cmdline_user_args().is_empty():
		print("Usage: godot -s merge_json.gd -- json1.md json2.md [...] --output-path output.md")
		quit(1)

	var output_path_idx := OS.get_cmdline_user_args().find("--output-path") + 1
	if output_path_idx == OS.get_cmdline_user_args().size():
		push_error("`--output-path` requires an argument. Aborting.")
		quit(1)

	var output_path := OS.get_cmdline_user_args()[output_path_idx]
	if "--output-path" not in OS.get_cmdline_user_args():
		push_error("`--output-path path/to/output.md` must be used at the end of the command line (preceded by paths of individual JSON benchmark run files). Aborting.")
		quit(1)

	var jsons: Array[Dictionary] = []
	for file_idx in OS.get_cmdline_user_args().size():
		if file_idx < output_path_idx - 1:
			jsons.push_back(JSON.parse_string(FileAccess.get_file_as_string(OS.get_cmdline_user_args()[file_idx])))

	print("Saving merged JSON to: %s" % output_path)

	var benchmarks_list := []

	# Gather list of all benchmarks, without any results for now.
	for json in jsons:
		for benchmark in json.benchmarks:
			var new_dict := {
				category = benchmark.category,
				name = benchmark.name,
				results = {},  # We'll add results later once we've gathered all benchmark names.
			}
			if not benchmarks_list.has(new_dict):
				benchmarks_list.push_back(new_dict)

	# Populate results in all benchmarks.
	for benchmark_idx in benchmarks_list.size():
		var benchmark: Dictionary = benchmarks_list[benchmark_idx]
		for json in jsons:
			for json_benchmark in json.benchmarks:
				if json_benchmark.category == benchmark.category and json_benchmark.name == benchmark.name:
					benchmark.results.merge(json_benchmark.results)

	var result: Dictionary = jsons[0]
	result.benchmarks = benchmarks_list

	var file_access := FileAccess.open(output_path, FileAccess.WRITE)
	file_access.store_string(JSON.stringify(result))

	quit()
