extends "res://benchmarks/rendering/polygon_2d/polygon_2d_base.gd"

const NUMBER_OF_POLYGONS := 1000


func _ready() -> void:
	fill_with_polygons(NUMBER_OF_POLYGONS)
