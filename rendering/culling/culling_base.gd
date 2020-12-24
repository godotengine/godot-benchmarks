extends Node3D

var objects = []
var object_xforms = []
var lights = []
var light_instances = []
var light_instance_xforms = []
var meshes = []

func fill_with_objects(object_amount,unshaded = false):
	
	var m = BoxMesh.new()
	meshes.append(m)
	m = SphereMesh.new()
	meshes.append(m)
	m = CapsuleMesh.new()
	meshes.append(m)
	m = CylinderMesh.new()
	meshes.append(m)
	m = PrismMesh.new()
	meshes.append(m)

	for m in meshes:
		
		var s = Shader.new()
		
		var st = "shader_type spatial; "+("render_mode unshaded;" if unshaded else "")+"void fragment() { ALBEDO = vec3("+str(randf(),",",randf(),",",randf())+"); }"
		print(st)
		s.code = st
		var mat = ShaderMaterial.new()
		mat.shader = s;
		m.material = mat

	var cam := ($Camera3D as Camera3D)
	var zn = 2
	var zextent = cam.far - zn
	var ss = get_tree().root.size
	var from = cam.project_position(Vector2(0,ss.y),zextent)
	var extents = cam.project_position(Vector2(ss.x,0),zextent) - from
	
	for i in range(object_amount):
		var xf = Transform()
		xf.origin = Vector3(from.x + randf() * extents.x,from.y + randf() * extents.y, - (zn + zextent * randf()))
		var ins = RenderingServer.instance_create()
		RenderingServer.instance_set_base(ins,meshes[i % meshes.size()].get_rid())
		RenderingServer.instance_set_scenario(ins,get_world_3d().scenario)
		RenderingServer.instance_set_transform(ins,xf)

		objects.append(ins)		
		object_xforms.append(xf)
	
func fill_with_omni_lights(amount,use_shadows=true):

	var cam := ($Camera3D as Camera3D)
	var zn = 2
	var zextent = cam.far - zn
	var ss = get_tree().root.size
	var from = cam.project_position(Vector2(0,ss.y),zextent)
	var extents = cam.project_position(Vector2(ss.x,0),zextent) - from

	var l = RenderingServer.omni_light_create()
	RenderingServer.light_set_param(l,RenderingServer.LIGHT_PARAM_RANGE,10)
	RenderingServer.light_set_shadow(l,use_shadows)
	RenderingServer.light_omni_set_shadow_mode(l,RenderingServer.LIGHT_OMNI_SHADOW_DUAL_PARABOLOID) # faster
	lights.append(l)
	for i in range(amount):
		var xf = Transform()
		xf.origin = Vector3(from.x + randf() * extents.x,from.y + randf() * extents.y, - (zn + zextent * randf()))
		var ins = RenderingServer.instance_create()
		RenderingServer.instance_set_base(ins,l)
		RenderingServer.instance_set_scenario(ins,get_world_3d().scenario)
		RenderingServer.instance_set_transform(ins,xf)

		light_instances.append(ins)		
		light_instance_xforms.append(xf)

func _exit_tree():
	for o in objects:
		RenderingServer.free_rid(o)
		
	for l in lights:
		RenderingServer.free_rid(l)

	for l in light_instances:
		RenderingServer.free_rid(l)

	meshes.clear()
	
	
