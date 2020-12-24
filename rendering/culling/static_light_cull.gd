extends "res://rendering/culling/culling_base.gd"


func _ready():
	fill_with_objects(10000)
	fill_with_omni_lights(100)
