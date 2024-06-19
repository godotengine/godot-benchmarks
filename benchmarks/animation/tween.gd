extends Benchmark

const ICON := preload("res://icon.png")

var viewport_size := Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)


func _init() -> void:
	test_render_cpu = true


func tween_properties(n_of_properties: int) -> Node:
	var node := Node.new()
	var tween := node.create_tween()
	for i in n_of_properties:
		var node2d := Sprite2D.new()
		node2d.position = Vector2(
			randf_range(0.0, viewport_size.x), randf_range(0.0, viewport_size.y)
		)
		node2d.texture = ICON
		node.add_child(node2d)
		tween.parallel().tween_property(node2d, "position", viewport_size / 2.0, 5)
	return node


func tween_methods(n_of_methods: int) -> Node:
	var node := Node.new()
	for i in n_of_methods:
		var tween := node.create_tween()
		var node2d := Sprite2D.new()
		node2d.position = Vector2(
			randf_range(0.0, viewport_size.x), randf_range(0.0, viewport_size.y)
		)
		node2d.texture = ICON
		node.add_child(node2d)
		tween.tween_method(node2d.rotate, 0.0, 0.01, 5)
	return node


func benchmark_tween_100_properties() -> Node:
	return tween_properties(100)


func benchmark_animate_1000_tween_methods() -> Node:
	return tween_methods(1000)
