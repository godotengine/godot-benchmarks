extends Benchmark

const NUMBER_OF_OBJECTS := 10_000
const NUMBER_OF_OMNI_LIGHTS := 100


func _init() -> void:
	test_render_cpu = true
	test_render_gpu = true


class TestScene:
	extends Node3D
	var objects: Array[RID] = []
	var object_xforms: Array[Transform3D] = []
	var lights: Array[RID] = []
	var light_instances: Array[RID] = []
	var light_instance_xforms: Array[Transform3D] = []
	var meshes: Array[PrimitiveMesh] = []
	var cam := Camera3D.new()
	var dynamic_instances: Array[RID]
	var dynamic_instances_xforms: Array[Transform3D]
	var dynamic_instances_rotate := false
	var time_accum := 0.0
	var unshaded := false
	var use_shadows := false
	var fill_with_objects := false
	var fill_with_omni_lights := false

	func _init() -> void:
		cam.far = 200.0
		cam.transform.origin.z = 0.873609
		add_child(cam)

	func _ready() -> void:
		cam.make_current()
		if fill_with_objects:
			do_fill_with_objects()
		if fill_with_omni_lights:
			do_fill_with_omni_lights()

	func do_fill_with_objects() -> void:
		meshes.append(BoxMesh.new())
		meshes.append(SphereMesh.new())
		meshes.append(CapsuleMesh.new())
		meshes.append(CylinderMesh.new())
		meshes.append(PrismMesh.new())

		for mesh in meshes:
			var shader := Shader.new()
			var shader_string := (
				"""
				shader_type spatial;
				%s
				void fragment() {
					ALBEDO = vec3(%s, %s, %s);
				}
				"""
				% [
					"render_mode unshaded;\n" if unshaded else "",
					str(randf()).pad_decimals(3),
					str(randf()).pad_decimals(3),
					str(randf()).pad_decimals(3),
				]
			)
			shader.code = shader_string
			var material := ShaderMaterial.new()
			material.shader = shader
			mesh.material = material

		var zn := 2
		var zextent := cam.far - zn
		var ss := get_tree().root.get_visible_rect().size
		var from := cam.project_position(Vector2(0, ss.y), zextent)
		var extents := cam.project_position(Vector2(ss.x, 0), zextent) - from

		for i in NUMBER_OF_OBJECTS:
			var xf := Transform3D()
			xf.origin = Vector3(
				from.x + randf() * extents.x,
				from.y + randf() * extents.y,
				-(zn + zextent * randf())
			)
			var ins := RenderingServer.instance_create()
			RenderingServer.instance_set_base(ins, meshes[i % meshes.size()].get_rid())
			RenderingServer.instance_set_scenario(ins, get_world_3d().scenario)
			RenderingServer.instance_set_transform(ins, xf)

			objects.append(ins)
			object_xforms.append(xf)

	func do_fill_with_omni_lights() -> void:
		var zn := 2
		var zextent := cam.far - zn
		var ss := get_tree().root.get_visible_rect().size
		var from := cam.project_position(Vector2(0, ss.y), zextent)
		var extents := cam.project_position(Vector2(ss.x, 0), zextent) - from

		var light := RenderingServer.omni_light_create()
		RenderingServer.light_set_param(light, RenderingServer.LIGHT_PARAM_RANGE, 10)
		RenderingServer.light_set_shadow(light, use_shadows)
		# Dual parabolid shadows are faster than cubemap shadows.
		RenderingServer.light_omni_set_shadow_mode(
			light, RenderingServer.LIGHT_OMNI_SHADOW_DUAL_PARABOLOID
		)
		lights.append(light)

		for i in NUMBER_OF_OMNI_LIGHTS:
			var xf := Transform3D()
			xf.origin = Vector3(
				from.x + randf() * extents.x,
				from.y + randf() * extents.y,
				-(zn + zextent * randf())
			)
			var ins := RenderingServer.instance_create()
			RenderingServer.instance_set_base(ins, light)
			RenderingServer.instance_set_scenario(ins, get_world_3d().scenario)
			RenderingServer.instance_set_transform(ins, xf)

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

	func _process(delta: float) -> void:
		if not (dynamic_instances and dynamic_instances_xforms):
			return

		time_accum += delta * 4.0

		for i in dynamic_instances.size():
			var xf := dynamic_instances_xforms[i]
			var angle := i * PI * 2.0 / dynamic_instances.size()
			if dynamic_instances_rotate:
				xf = xf.rotated_local(Vector3.RIGHT, angle * sin(time_accum) * 2.0)
			else:
				xf.origin += Vector3(sin(angle), cos(angle), 0.0) * sin(time_accum) * 2.0
			RenderingServer.instance_set_transform(dynamic_instances[i], xf)


func benchmark_basic_cull() -> TestScene:
	var rv := TestScene.new()
	rv.fill_with_objects = true
	rv.unshaded = true
	return rv


func benchmark_directional_light_cull() -> TestScene:
	var rv := TestScene.new()
	rv.fill_with_objects = true
	var light := DirectionalLight3D.new()
	light.shadow_enabled = true
	light.rotation = Vector3(-0.6, 0.3, -0.3)
	light.position.x = 2
	rv.add_child(light)
	return rv


func benchmark_dynamic_cull() -> TestScene:
	var rv := TestScene.new()
	rv.fill_with_objects = true
	rv.dynamic_instances = rv.objects
	rv.dynamic_instances_xforms = rv.object_xforms
	return rv


func benchmark_dynamic_rotate_cull() -> TestScene:
	var rv := TestScene.new()
	rv.dynamic_instances_rotate = true
	rv.fill_with_objects = true
	rv.dynamic_instances = rv.objects
	rv.dynamic_instances_xforms = rv.object_xforms
	return rv


func benchmark_dynamic_light_cull() -> TestScene:
	var rv := TestScene.new()
	rv.fill_with_objects = true
	rv.fill_with_omni_lights = true
	rv.dynamic_instances = rv.light_instances
	rv.dynamic_instances_xforms = rv.light_instance_xforms
	return rv


func benchmark_dynamic_light_cull_with_shadows() -> TestScene:
	var rv := TestScene.new()
	rv.fill_with_objects = true
	rv.fill_with_omni_lights = true
	rv.use_shadows = true
	rv.dynamic_instances = rv.light_instances
	rv.dynamic_instances_xforms = rv.light_instance_xforms
	return rv


func benchmark_static_light_cull() -> TestScene:
	var rv := TestScene.new()
	rv.fill_with_objects = true
	rv.fill_with_omni_lights = true
	return rv
