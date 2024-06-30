extends Benchmark

const SPREAD_H := 25.0
const SPREAD_V := 10.0


class TestScene:
	extends Node3D

	var collision_scene := preload("res://supplemental/8ball.glb")
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
		var collision_node := collision_scene.instantiate() as Node3D
		collision_node.rotate_y(PI / 2.0)
		collision_node.scale = Vector3(7, 7, 7)
		add_child(collision_node)
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


func benchmark_triangle_mesh_3d_1000_rigidbodies() -> TestScene:
	return TestScene.new(1000)
