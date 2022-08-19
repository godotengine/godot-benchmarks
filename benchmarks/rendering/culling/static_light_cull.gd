extends "res://benchmarks/rendering/culling/culling_base.gd"

const NUMBER_OF_OBJECTS = 10_000
const NUMBER_OF_OMNI_LIGHTS = 100


func _ready() -> void:
	fill_with_objects(NUMBER_OF_OBJECTS)
	fill_with_omni_lights(NUMBER_OF_OMNI_LIGHTS, false)
