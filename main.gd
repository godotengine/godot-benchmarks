extends Panel

var items := []
var include_benchmarks_glob := ""
var exclude_benchmarks_glob := ""

@onready var tree := $Tree as Tree


func _ready() -> void:
	# Use a fixed random seed to improve reproducibility of results.
	seed(0x60d07)
	
	# No point in copying JSON without any results yet.
	$CopyJSON.visible = false

	tree.columns = 6
	tree.set_column_titles_visible(true)
	tree.set_column_title(0, "Test Name")
	tree.set_column_title(1, "Render CPU")
	tree.set_column_title(2, "Render GPU")
	tree.set_column_title(3, "Idle")
	tree.set_column_title(4, "Physics")
	tree.set_column_title(5, "Wall Clock Time")

	var root := tree.create_item()
	var categories := {}

	for i in Manager.get_test_count():
		var test_name := Manager.get_test_name(i)
		var category := Manager.get_test_category(i)
		var results := Manager.get_test_result(i)
		var path := Manager.get_test_path(i)

		if category not in categories:
			var c := tree.create_item(root)
			c.set_text(0, category)
			categories[category] = c

		var item := tree.create_item(categories[category])
		item.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
		item.set_text(0, test_name)
		item.set_editable(0, true)
		# Store the full scene path each TreeItem points towards (for include/exclude glob checking).
		item.set_meta("path", path)

		if results:
			$CopyJSON.visible = true

			if results.render_cpu:
				item.set_text(1, "%s ms" % str(results.render_cpu).pad_decimals(2))
			if results.render_gpu:
				item.set_text(2, "%s ms" % str(results.render_gpu).pad_decimals(2))
			if results.idle:
				item.set_text(3, "%s ms" % str(results.idle).pad_decimals(2))
			if results.physics:
				item.set_text(4, "%s ms" % str(results.physics).pad_decimals(2))
			if results.time:
				# Wall clock time is a much larger value, and therefore doesn't need
				# to be displayed very accurately.
				item.set_text(5, "%d ms" % results.time)

		items.append(item)

	# Select all benchmarks since the user most likely wants to run all of them by default.
	_on_SelectAll_pressed()

	# Parse valid command-line arguments of the form `--key=value` into a dictionary.
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--include-benchmarks="):
			var key_value := argument.split("=")
			# Remove quotes around the argument's value, so that "`rendering/culling/*`"
			# becomes `rendering/culling/*` for globbing.
			include_benchmarks_glob = key_value[1].trim_prefix('"').trim_suffix('"').trim_prefix("'").trim_suffix("'")
			print("Using benchmark include glob specified on command line: %s" % include_benchmarks_glob)

		if argument.begins_with("--exclude-benchmarks="):
			var key_value := argument.split("=")
			# Remove quotes around the argument's value, so that "`rendering/culling/*`"
			# becomes `rendering/culling/*` for globbing.
			exclude_benchmarks_glob = key_value[1].trim_prefix('"').trim_suffix('"').trim_prefix("'").trim_suffix("'")
			print("Using benchmark exclude glob specified on command line: %s" % exclude_benchmarks_glob)

	if "--run-benchmarks" in OS.get_cmdline_user_args():
		Manager.run_from_cli = true
		print("Running benchmarks as specified on command line.\n")
		_on_Run_pressed()


func _on_SelectAll_pressed() -> void:
	for item in items:
		item.set_checked(0, true)
	_on_Tree_item_edited()


func _on_SelectNone_pressed() -> void:
	for item in items:
		item.set_checked(0, false)
	_on_Tree_item_edited()


func _on_CopyJSON_pressed() -> void:
	var json := JSON.new()
	DisplayServer.clipboard_set(json.stringify(Manager.get_results_dict(), "\t"))


func _on_Run_pressed() -> void:
	var queue := []
	var index := 0
	var paths := []
	for item in items:
		var path: String = item.get_meta("path").trim_prefix("res://benchmarks/").trim_suffix(".tscn")
		
		if not include_benchmarks_glob.is_empty():
			if not path.match(include_benchmarks_glob):
				item.set_checked(0, false)
				
		if not exclude_benchmarks_glob.is_empty():
			if path.match(exclude_benchmarks_glob):
				item.set_checked(0, false)

		if item.is_checked(0):
			queue.push_back(index)
			paths.push_back(path)

		index += 1

	if index >= 1:
		print_rich("[b]Running %d benchmarks:[/b] %s " % [queue.size(), ", ".join(paths)])
		Manager.benchmark(queue, "res://main.tscn")
	else:
		print_rich("[color=red][b]ERROR:[/b] No benchmarks to run.[/color]")
		if Manager.run_from_cli:
			print("       Double-check the syntax of the benchmarks include/exclude glob (quotes are required).")
			print_rich('       Example usage: [code]godot -- --run-benchmarks --include-benchmarks="rendering/culling/*" --exclude-benchmarks="rendering/culling/basic_cull"[/code]')
			get_tree().quit(1)


func _on_Tree_item_edited() -> void:
	$Run.disabled = true
	for item in items:
		if item.is_checked(0):
			$Run.disabled = false
			break
