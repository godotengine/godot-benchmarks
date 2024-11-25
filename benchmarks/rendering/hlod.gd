extends Benchmark

# Benchmarks very deep HLODs and their interactions with occlusion culling.
#
# benchmark_flat/cull_*():
#   Test the interaction between HLODs and culling.
# benchmark_*_fast/slow():
#   Test the effect of faster camera (more visibility range changes per second).
# benchmark_*_slow/deep():
#   Test the effect of a deeper HLOD tree showing the same LODs.
#   Should have identical performance but slower construction time.


# Approximate limit
const NUMBER_OF_OBJECTS : float = 10_000

var wire_mesh : Mesh

func _init() -> void:
	test_render_cpu = true
	test_render_gpu = true
	var orad := 1.35     #outer radius
	var irad := orad*0.8 #inner radius

	# Implement the square as a 4-sided circle, rotated 45 degrees
	wire_mesh = ImmediateMesh.new()
	wire_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	for i in 5:
		var ang : float = (i-0.5)*0.5*PI
		wire_mesh.surface_add_vertex(Vector3(cos(ang)*irad, 0, sin(ang)*irad))
		wire_mesh.surface_add_vertex(Vector3(cos(ang)*orad, 0, sin(ang)*orad))
	wire_mesh.surface_end()

	var material := StandardMaterial3D.new()
	material.emission = Color("#fff")
	material.emission_enabled = true
	material.cull_mode = StandardMaterial3D.CULL_DISABLED
	wire_mesh.surface_set_material(0, material)


class Rotater extends Node3D:
	var speed := 1.0
	func _init(_speed: float):
		speed = _speed
	func _process(delta: float) -> void:
		rotate_y(delta * speed)

func attach_model_recursive(parent: Node3D, recursion_depth: float, global_scale: float = 1.0, vp: String = ""):
	recursion_depth /= 4.0

	for y in 2:
		for x in 2:
			var model := MeshInstance3D.new()
			model.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_DISABLED
			model.visibility_parent = NodePath(vp)

			model.position.x = x-0.5
			model.position.z = y-0.5
			model.scale *= 0.5
			model.mesh = wire_mesh
			if recursion_depth > 1.0:
				model.visibility_range_begin = global_scale * sqrt(NUMBER_OF_OBJECTS) * 0.12
				model.visibility_range_begin_margin = 0.01
				attach_model_recursive(model, recursion_depth, global_scale/2.0, "..")
			parent.add_child(model)

func attach_occluder(parent: Node3D):
	var occluder := OccluderInstance3D.new()
	occluder.occluder = QuadOccluder3D.new()
	# Orient to match PlaneMesh
	occluder.occluder.size *= 2
	occluder.rotate_x(PI*-0.5)
	parent.add_child(occluder)


func create_plane(speed: float, obj_multiplier: float = 1.0) -> Node3D:
	var scene_root := Node3D.new()
	var rotater := Rotater.new(speed)
	var cam := Camera3D.new()
	cam.position.y = 0.3
	cam.position.z = 1.0
	cam.rotate_x(-.8)
	rotater.add_child(cam)
	scene_root.add_child(rotater)

	attach_occluder(scene_root)
	attach_model_recursive(scene_root, NUMBER_OF_OBJECTS*obj_multiplier)
	return scene_root

func create_cylinder(speed: float, obj_multiplier: float = 1.0) -> Node3D:
	var scene_root := Node3D.new()
	var rotater := Rotater.new(speed)
	var cam := Camera3D.new()
	# Place camera in middle of cylinder so that there's frustum culling
	cam.position.y = 1.1
	cam.position.z = -1.1
	cam.rotate_x(-.6)
	cam.rotate_y(1.5)
	rotater.add_child(cam)
	scene_root.add_child(rotater)

	const num_facets = 16
	for i in num_facets:
		# Alternate between two separate radii so that there's occlusion
		var radius : float = (i % 2) * 3.0 + 3.0
		var ang : float = i*PI*2.0/num_facets
		var panel := Node3D.new()
		panel.position.x = cos(ang) * radius
		panel.position.z = sin(ang) * radius
		panel.rotate_z(PI*0.5)
		panel.rotate_y(-ang)
		# Flip every other panel to make backface issues more apparent
		panel.rotate_y(i * PI)
		attach_occluder(panel)
		attach_model_recursive(panel, NUMBER_OF_OBJECTS*obj_multiplier/num_facets)
		scene_root.add_child(panel)
	return scene_root


func benchmark_flat_slow() -> Node3D:
	return create_plane(0.2)
func benchmark_flat_deep() -> Node3D:
	return create_plane(0.2, 4.0)
func benchmark_flat_fast() -> Node3D:
	return create_plane(5.0)

func benchmark_cull_slow() -> Node3D:
	return create_cylinder(0.2)
func benchmark_cull_deep() -> Node3D:
	return create_cylinder(0.2, 4.0)
func benchmark_cull_fast() -> Node3D:
	return create_cylinder(5.0)

# Smoke test
func benchmark_aaa_setup():
	for i in 20:
		var tmp := Node3D.new()
		attach_model_recursive(tmp, NUMBER_OF_OBJECTS)
		tmp.free()
