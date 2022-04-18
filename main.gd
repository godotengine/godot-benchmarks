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

	if "--run-benchmarks" in OS.get_cmdline_args():
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
	for item in items:
		if item.is_checked(0):
			queue.append(index)
		index += 1
		
	if index == 0:
		return

	print("Running %d benchmarks..." % items.size())
	Manager.benchmark(queue, $TestTime.value, "res://main.tscn")


func _on_Tree_item_edited() -> void:
	$Run.disabled = true
	for item in items:
		if item.is_checked(0):
			$Run.disabled = false
			break
