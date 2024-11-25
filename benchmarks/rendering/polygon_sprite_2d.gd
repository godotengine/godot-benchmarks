extends Benchmark

func _init() -> void:
	test_render_cpu = true
	test_render_gpu = true


class TestScene extends Node2D:
	var cam := Camera2D.new()
	var instances := []
	var instance_xforms := []
	var instance_amount := 0

	func _init(_instance_amount: int):
		instance_amount = _instance_amount
		add_child(cam)

	func _ready() -> void:
		var ss := get_tree().root.get_visible_rect().size
		for i in instance_amount:
			var xf := Transform2D()
			xf.origin = Vector2(randf_range(-ss.x, ss.x), randf_range(-ss.y, ss.y)) / 2.0

			var new_instance := create_instance()

			call_deferred("add_child", new_instance)
			new_instance.set_global_transform(xf)
			instances.append(new_instance)
			instance_xforms.append(xf)

	func create_instance() -> Node:
		return null

	func _exit_tree() -> void:
		for instance in instances:
			instance.queue_free()

class TestPolygon extends TestScene:
	func create_instance() -> Node:
		var new_polygon := Polygon2D.new()
		var vertices := PackedVector2Array()
		var p_scale = randf_range(30,50)
		for i in 32:
			vertices.append(Vector2(p_scale*cos(i * PI / 16),p_scale*sin(i * PI / 16)))
		new_polygon.polygon = vertices
		return new_polygon

class TestSprite extends TestScene:
	var sprite_texture := preload("res://icon.png")
	func create_instance() -> Node:
		var new_sprite := Sprite2D.new()
		new_sprite.texture = sprite_texture
		return new_sprite


func benchmark_10_polygon_2d():
	return TestPolygon.new(10)
func benchmark_100_polygon_2d():
	return TestPolygon.new(100)
func benchmark_1000_polygon_2d():
	return TestPolygon.new(1000)

func benchmark_50_sprite_2d():
	return TestSprite.new(50)
func benchmark_500_sprite_2d():
	return TestSprite.new(500)
func benchmark_5000_sprite_2d():
	return TestSprite.new(5000)
