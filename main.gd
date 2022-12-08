extends Panel

var items := []

# Prefix variables with `arg_` to have them automatically be parsed from command line arguments
var arg_include_benchmarks := ""
var arg_exclude_benchmarks := ""
var arg_save_json := ""
var arg_run_benchmarks := false

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

	for test_id in Manager.get_test_ids():
		var results : Manager.Results = Manager.test_results[test_id]
		var test_name := test_id.pretty_name()
		var category := test_id.pretty_category()

		if category not in categories:
			var c := tree.create_item(root)
			c.set_text(0, category)
			categories[category] = c

		var item := tree.create_item(categories[category])
		item.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
		item.set_text(0, test_name)
		item.set_editable(0, true)
		# Store the full scene path each TreeItem points towards (for include/exclude glob checking).
		item.set_meta("test_id", test_id)

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

	# Parse valid command-line arguments of the form `--key=value` into member variables.
	for argument in OS.get_cmdline_user_args():
		if not argument.begins_with("--"):
			print("Invalid argument: %s" % argument)
			continue

		var key_value := argument.substr(2).split("=", true, 1)
		var var_name := "arg_" + key_value[0].replace("-", "_")

		if var_name not in self:
			print("Invalid argument: %s" % argument)
			continue

		if key_value.size() == 1:
			self.set(var_name, true)
		else:
			# Remove quotes around the argument's value, so that `"example.json"` becomes `example.json`.
			self.set(var_name, key_value[1].trim_prefix('"').trim_suffix('"').trim_prefix("'").trim_suffix("'"))

		print("Variable %s set by command line to %s" % [var_name, self.get(var_name)])

	if arg_save_json:
		Manager.save_json_to_path = arg_save_json
	if arg_run_benchmarks:
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
	var test_ids : Array[Manager.TestID] = []
	for item in items:
		var test_id : Manager.TestID = item.get_meta("test_id")
		var path := test_id.to_string()

		if arg_include_benchmarks:
			if not path.match(arg_include_benchmarks):
				item.set_checked(0, false)

		if arg_exclude_benchmarks:
			if path.match(arg_exclude_benchmarks):
				item.set_checked(0, false)

		if item.is_checked(0):
			test_ids.push_back(test_id)

	if test_ids:
		print_rich("[b]Running %d benchmarks:[/b]\n\t%s\n" % [test_ids.size(), "\n\t".join(test_ids)])
		var return_path := ""
		# Automatically exit after running benchmarks for automation purposes.
		if not arg_run_benchmarks:
			return_path = get_tree().current_scene.scene_file_path
		Manager.benchmark(test_ids, return_path)
	else:
		print_rich("[color=red][b]ERROR:[/b] No benchmarks to run.[/color]")
		if arg_run_benchmarks:
			print("       Double-check the syntax of the benchmarks include/exclude glob (quotes are required).")
			print_rich('       Example usage: [code]godot -- --run-benchmarks --include-benchmarks="rendering/culling/*" --exclude-benchmarks="rendering/culling/basic_cull"[/code]')
			get_tree().quit(1)


func _on_Tree_item_edited() -> void:
	$Run.disabled = true
	for item in items:
		if item.is_checked(0):
			$Run.disabled = false
			break
