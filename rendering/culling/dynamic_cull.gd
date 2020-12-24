extends "res://rendering/culling/culling_base.gd"

var time_accum = 0.0
func _process(delta):
	time_accum += delta * 4.0
	for i in range(objects.size()):
		var xf = object_xforms[i]
		var angle = i * PI * 2.0 / objects.size()
		xf.origin += Vector3(sin(angle),cos(angle),0.0) * sin(time_accum) * 2.0
		RenderingServer.instance_set_transform(objects[i],xf)

func _ready():
	fill_with_objects(10000)
