extends Panel

var items := []

@onready var tree := $Tree as Tree


func _ready() -> void:
	# Use a fixed random seed to improve reproducibility of results.
	seed(0x60d07)

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
		
		if category not in categories:
			var c := tree.create_item(root)
			c.set_text(0, category)
			categories[category] = c

		var item := tree.create_item(categories[category])
		item.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
		item.set_text(0, test_name)
		item.set_editable(0, true)
		
		if results:
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


func _on_SelectAll_pressed() -> void:
	for item in items:
		item.set_checked(0, true)
	_on_Tree_item_edited()


func _on_SelectNone_pressed() -> void:
	for item in items:
		item.set_checked(0, false)
	_on_Tree_item_edited()


func _on_CopyJSON_pressed() -> void:
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

	var json := JSON.new()
	DisplayServer.clipboard_set(json.stringify(dict, "\t"))


func _on_Run_pressed() -> void:
	var queue := []
	var index := 0
	for item in items:
		if item.is_checked(0):
			queue.append(index)
		index += 1
		
	if index == 0:
		return

	Manager.benchmark(queue, $TestTime.value, "res://main.tscn")


func _on_Tree_item_edited() -> void:
	$Run.disabled = true
	for item in items:
		if item.is_checked(0):
			$Run.disabled = false
			break
