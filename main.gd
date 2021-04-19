extends Panel

var items = []
func _ready():
	$Tree.columns = 6
	$Tree.set_column_titles_visible(true)
	$Tree.set_column_title(0,"Test Name")
	$Tree.set_column_title(1,"Render CPU")
	$Tree.set_column_title(2,"Render GPU")
	$Tree.set_column_title(3,"Idle")
	$Tree.set_column_title(4,"Physics")
	$Tree.set_column_title(5,"Wall Clock Time")

	var root = $Tree.create_item()
	var categories = {}
	for i in range(Manager.get_test_count()):
		var name = Manager.get_test_name(i)
		var category = Manager.get_test_category(i)
		var results = Manager.get_test_result(i)
		if (not category in categories):
			var c = $Tree.create_item(root) as TreeItem
			c.set_text(0,category)
			categories[category]=c

		var item = $Tree.create_item(categories[category]) as TreeItem
		item.set_cell_mode(0,TreeItem.CELL_MODE_CHECK)
		item.set_text(0,name)
		item.set_editable(0,true)
		if results:
			if (results.render_cpu):
				item.set_text(1,str(results.render_cpu," ms"))
			if (results.render_gpu):
				item.set_text(2,str(results.render_gpu," ms"))
			if (results.idle):
				item.set_text(3,str(results.idle," ms"))
			if (results.physics):
				item.set_text(4,str(results.physics," ms"))
			if (results.time):
				item.set_text(5,str(results.time," ms"))

		items.append(item)




func _on_SelectAll_pressed():
	for it in items:
		it.set_checked(0,true)
	_on_Tree_item_edited()


func _on_SelectNone_pressed():
	for it in items:
		it.set_checked(0,false)
	_on_Tree_item_edited()

func _on_CopyJSON_pressed():
	var json="[\n"
	for i in range(Manager.get_test_count()):
		if (i>0):
			json+=",\n"
		var name = Manager.get_test_name(i)
		var category = Manager.get_test_category(i)
		var results = Manager.get_test_result(i)
		json+="{\n"
		json+='\t"name":"'+name+'",\n'
		json+='\t"category":"'+category+'"'
		if results:
			json+=',\n'
			json+='\t"render_cpu":'+str(results.render_cpu)+',\n'
			json+='\t"render_gpu":'+str(results.render_gpu)+',\n'
			json+='\t"idle":'+str(results.idle)+',\n'
			json+='\t"physics":'+str(results.physics)+',\n'
			json+='\t"time":'+str(results.time)+'\n'
		else:
			json+='\n'
		json+="}\n"
	json+="]\n"
	DisplayServer.clipboard_set(json)




func _on_Run_pressed():
	if ($Run.disabled):
		return
	var queue=[]
	var idx = 0
	for it in items:
		if (it.is_checked(0)):
			queue.append(idx)
		idx+=1
	if (idx==0):
		return

	Manager.benchmark(queue,$TestTime.value,"res://main.tscn")


func _on_Tree_item_edited():
	$Run.disabled = true
	for it in items:
		if (it.is_checked(0)):
			$Run.disabled = false
			break
