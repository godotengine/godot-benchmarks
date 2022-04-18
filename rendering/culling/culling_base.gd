extends Node3D

var objects := []
var object_xforms := []
var lights := []
var light_instances := []
var light_instance_xforms := []
var meshes := []


func fill_with_objects(object_amount: int, unshaded: bool = false) -> void:
	meshes.append(BoxMesh.new())
	meshes.append(SphereMesh.new())
	meshes.append(CapsuleMesh.new())
	meshes.append(CylinderMesh.new())
	meshes.append(PrismMesh.new())

	for mesh in meshes:
		var shader := Shader.new()
		var shader_string := """
shader_type spatial;
%s
void fragment() {
	ALBEDO = vec3(%s, %s, %s);
}
""" % [
	"render_mode unshaded;\n" if unshaded else "",
	str(randf()).pad_decimals(3),
	str(randf()).pad_decimals(3),
	str(randf()).pad_decimals(3),
]
		shader.code = shader_string
		var material := ShaderMaterial.new()
		material.shader = shader
		mesh.material = material

	var cam := $Camera3D as Camera3D
	var zn := 2
	var zextent := cam.far - zn
	var ss := get_tree().root.size
	var from := cam.project_position(Vector2(0, ss.y), zextent)
	var extents := cam.project_position(Vector2(ss.x, 0), zextent) - from

	for i in object_amount:
		var xf := Transform3D()
		xf.origin = Vector3(from.x + randf() * extents.x,from.y + randf() * extents.y, - (zn + zextent * randf()))
		var ins := RenderingServer.instance_create()
		RenderingServer.instance_set_base(ins, meshes[i % meshes.size()].get_rid())
		RenderingServer.instance_set_scenario(ins, get_world_3d().scenario)
		RenderingServer.instance_set_transform(ins, xf)

		objects.append(ins)
		object_xforms.append(xf)

func fill_with_omni_lights(amount: int, use_shadows: bool = true) -> void:
	var cam := $Camera3D as Camera3D
	var zn := 2
	var zextent := cam.far - zn
	var ss := get_tree().root.size
	var from := cam.project_position(Vector2(0,ss.y),zextent)
	var extents := cam.project_position(Vector2(ss.x,0),zextent) - from

	var light := RenderingServer.omni_light_create()
	RenderingServer.light_set_param(light, RenderingServer.LIGHT_PARAM_RANGE,10)
	RenderingServer.light_set_shadow(light, use_shadows)
	# Dual parabolid shadows are faster than cubemap shadows.
	RenderingServer.light_omni_set_shadow_mode(light, RenderingServer.LIGHT_OMNI_SHADOW_DUAL_PARABOLOID)
	lights.append(light)
	
	for i in amount:
		var xf := Transform3D()
		xf.origin = Vector3(from.x + randf() * extents.x,from.y + randf() * extents.y, - (zn + zextent * randf()))
		var ins := RenderingServer.instance_create()
		RenderingServer.instance_set_base(ins, light)
		RenderingServer.instance_set_scenario(ins,get_world_3d().scenario)
		RenderingServer.instance_set_transform(ins,xf)

		light_instances.append(ins)
		light_instance_xforms.append(xf)

func _exit_tree() -> void:
	for object in objects:
		RenderingServer.free_rid(object)

	for light in lights:
		RenderingServer.free_rid(light)

	for light_instance in light_instances:
		RenderingServer.free_rid(light_instance)

	meshes.clear()


