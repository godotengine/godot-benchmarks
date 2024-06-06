extends Benchmark

const ICON := preload("res://icon.png")


func _init() -> void:
	test_render_cpu = true
	test_render_gpu = true


class TestScene:
	extends Node2D
	var shape_amount := 0
	var window_size: Vector2i
	var draw_every_frame := false

	func _init(_shape_amount: int, _draw_every_frame: bool) -> void:
		shape_amount = _shape_amount
		draw_every_frame = _draw_every_frame

	func _ready() -> void:
		window_size = get_window().size
		set_process(draw_every_frame)

	func _process(_delta: float) -> void:
		queue_redraw()

	func _draw() -> void:
		for i in shape_amount:
			var x := (i * 20) % window_size.x
			var y := (i * 200) / window_size.x
			var center := Vector2(x, y)
			var remainder := i % 5
			match remainder:
				0:
					draw_circle(center, 1.0, Color.GREEN)
				1:
					draw_rect(Rect2(center - Vector2.ONE, Vector2.ONE * 2.0), Color.GREEN)
				2:
					draw_line(center - Vector2.ONE, center + Vector2.ONE, Color.GREEN)
				3:
					draw_dashed_line(center - Vector2.ONE, center + Vector2.ONE, Color.GREEN)
				4:
					draw_texture(ICON, center)


func benchmark_draw_5000_shapes_once() -> TestScene:
	return TestScene.new(5000, false)


func benchmark_draw_5000_shapes_every_frame() -> TestScene:
	return TestScene.new(5000, true)


func benchmark_draw_10_000_shapes_once() -> TestScene:
	return TestScene.new(10_000, false)


func benchmark_draw_10_000_shapes_every_frame() -> TestScene:
	return TestScene.new(10_000, true)


func benchmark_draw_20_000_shapes_once() -> TestScene:
	return TestScene.new(20_000, false)


func benchmark_draw_20_000_shapes_every_frame() -> TestScene:
	return TestScene.new(20_000, true)
