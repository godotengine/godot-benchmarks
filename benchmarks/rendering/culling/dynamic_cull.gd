extends "res://benchmarks/rendering/culling/culling_base.gd"

const NUMBER_OF_OBJECTS = 10_000

var time_accum := 0.0


func _ready() -> void:
	fill_with_objects(NUMBER_OF_OBJECTS)


func _process(delta: float) -> void:
	time_accum += delta * 4.0
	
	for i in objects.size():
		var xf = object_xforms[i]
		var angle = i * PI * 2.0 / objects.size()
		xf.origin += Vector3(sin(angle), cos(angle), 0.0) * sin(time_accum) * 2.0
		RenderingServer.instance_set_transform(objects[i], xf)
