extends "res://benchmarks/rendering/culling/culling_base.gd"

const NUMBER_OF_OBJECTS = 10_000
const NUMBER_OF_OMNI_LIGHTS = 100

@export var use_shadows := false

var time_accum := 0.0


func _ready() -> void:
	fill_with_objects(NUMBER_OF_OBJECTS)
	fill_with_omni_lights(NUMBER_OF_OMNI_LIGHTS, use_shadows)


func _process(delta: float) -> void:
	time_accum += delta * 4.0
	
	for i in light_instances.size():
		var xf = light_instance_xforms[i]
		var angle = i * PI * 2.0 / light_instances.size()
		xf.origin += Vector3(sin(angle), cos(angle), 0.0) * sin(time_accum) * 2.0
		RenderingServer.instance_set_transform(light_instances[i], xf)
