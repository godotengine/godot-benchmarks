extends Benchmark

const SPREAD_H := 20.0
const SPREAD_V := 80.0


class TestScene:
	extends Node3D

	var n_of_rigidbodies: int
	var shapes: Array[Shape3D] = [
		BoxShape3D.new(),
		CapsuleShape3D.new(),
		SphereShape3D.new(),
	]
	var meshes: Array[Mesh] = [
		BoxMesh.new(),
		CapsuleMesh.new(),
		SphereMesh.new(),
	]

	func _init(_n_of_rigidbodies: int) -> void:
		n_of_rigidbodies = _n_of_rigidbodies

	func _ready() -> void:
		var softbody := SoftBody3D.new()
		var plane_mesh := PlaneMesh.new()
		plane_mesh.size = Vector2(60, 60)
		plane_mesh.subdivide_depth = 21
		plane_mesh.subdivide_width = 21
		softbody.mesh = plane_mesh
		softbody.set_point_pinned(11, true)
		softbody.set_point_pinned(253, true)
		softbody.set_point_pinned(275, true)
		softbody.set_point_pinned(517, true)
		add_child(softbody)
		if Manager.visualize:
			var camera := Camera3D.new()
			camera.position = Vector3(0.0, 20.0, 20.0)
			camera.rotate_x(-0.8)
			add_child(camera)

		for i in n_of_rigidbodies:
			var rigid := RigidBody3D.new()
			rigid.position = Vector3(
				randf_range(-SPREAD_H, SPREAD_H),
				randf_range(0.0, SPREAD_V),
				randf_range(-SPREAD_H, SPREAD_H)
			)
			add_random_shape(rigid)
			add_child(rigid)

	func add_random_shape(parent: CollisionObject3D) -> void:
		var r := randi() % shapes.size()
		var collision_shape := CollisionShape3D.new()
		collision_shape.shape = shapes[r]
		if Manager.visualize:
			var mesh_instance := MeshInstance3D.new()
			mesh_instance.mesh = meshes[r]
			parent.add_child(mesh_instance)
		parent.add_child(collision_shape)


func _init() -> void:
	benchmark_time = 10e6
	test_physics = true
	test_idle = true


func benchmark_softbody_3d_500_rigidbodies() -> TestScene:
	return TestScene.new(500)
