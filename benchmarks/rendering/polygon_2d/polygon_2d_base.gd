extends Node2D

var Polygon := preload("res://benchmarks/rendering/polygon_2d/_polygon_2d.tscn") as PackedScene
var polygons := []
var polygon_xforms := []

func fill_with_polygons(polygon_amount: int) -> void:
	var cam := $Camera2D as Camera2D
	var ss := get_tree().root.size
	var center := cam.get_screen_center_position()
	for polygon in polygon_amount:
		var xf := Transform2D()
		xf.origin = Vector2(center.x + randf() * ss.x, center.y + randf() * ss.y)
		var new_polygon = Polygon.instantiate() as Polygon2D
		var vertices := PackedVector2Array()
		var p_scale = randf_range(30,50)
		for i in 32:
			vertices.append(Vector2(p_scale*cos(i * PI / 16),p_scale*sin(i * PI / 16)))
		new_polygon.polygon = vertices
		call_deferred("add_child", new_polygon)
		new_polygon.set_global_transform(xf)

		polygons.append(new_polygon)
		polygon_xforms.append(xf)

func _exit_tree() -> void:
	for polygon in polygons:
		polygon.queue_free()
