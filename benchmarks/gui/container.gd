extends Benchmark


class SortContainer:
	extends BoxContainer

	func _process(_delta: float) -> void:
		queue_sort()


class ResizeContainer:
	extends BoxContainer

	var time_accum := 0.0

	func _process(delta: float) -> void:
		time_accum += delta * 4.0
		size += Vector2(sin(time_accum), cos(time_accum)) * 4.0


func _init() -> void:
	test_render_cpu = true


func benchmark_container_sorting() -> SortContainer:
	var container := SortContainer.new()
	for i in 1000:
		var control := Control.new()
		container.add_child(control)
	return container


func benchmark_container_resizing() -> ResizeContainer:
	var container := ResizeContainer.new()
	var parent: Container = container
	for i in 20:
		var random := randi() % 9
		var control: Container
		match random:
			0:
				control = HBoxContainer.new()
			1:
				control = VBoxContainer.new()
			2:
				control = GridContainer.new()
			3:
				control = AspectRatioContainer.new()
			4:
				control = HFlowContainer.new()
			5:
				control = VFlowContainer.new()
			6:
				control = PanelContainer.new()
			7:
				control = CenterContainer.new()
			8:
				control = MarginContainer.new()
		parent.add_child(control)
		parent = control
	return container
