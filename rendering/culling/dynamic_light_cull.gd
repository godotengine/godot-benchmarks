extends "res://rendering/culling/culling_base.gd"

@export var use_shadows := false
var time_accum = 0.0
func _process(delta):
	time_accum += delta * 4.0
	for i in range(light_instances.size()):
		var xf = light_instance_xforms[i]
		var angle = i * PI * 2.0 / light_instances.size()
		xf.origin += Vector3(sin(angle),cos(angle),0.0) * sin(time_accum) * 2.0
		RenderingServer.instance_set_transform(light_instances[i],xf)

func _ready():
	fill_with_objects(10000)
	fill_with_omni_lights(100,use_shadows)
