extends "res://rendering/culling/culling_base.gd"

const NUMBER_OF_OBJECTS = 10_000


func _ready() -> void:
	fill_with_objects(NUMBER_OF_OBJECTS, true)
