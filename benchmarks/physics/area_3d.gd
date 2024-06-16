extends Benchmark

const SPREAD_H := 20.0
const SPREAD_V := 10.0


class TestScene:
	extends Node3D

	var num_character_bodies: int
	var num_area_3d: int
	var visualize := true
	var area_3d_nodes: Array[Area3D]
	var window_size: Vector2i
	var time_accum := 0.0
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

	func _init(_num_character_bodies: int, _num_area_3d: int, _visualize: bool) -> void:
		num_character_bodies = _num_character_bodies
		num_area_3d = _num_area_3d
		visualize = _visualize

	func _ready() -> void:
		window_size = get_window().size
		if visualize:
			var camera := Camera3D.new()
			camera.position = Vector3(0.0, 20.0, 20.0)
			camera.rotate_x(-0.8)
			add_child(camera)
		for i in num_character_bodies:
			var character_body := CharacterBody3D.new()
			character_body.position = Vector3(
				randf_range(-SPREAD_H, SPREAD_H),
				randf_range(0.0, SPREAD_V),
				randf_range(-SPREAD_H, SPREAD_H)
			)
			add_random_shape(character_body)
			add_child(character_body)

		for i in num_area_3d:
			var area_2d := Area3D.new()
			area_2d.position = Vector3(
				randf_range(-SPREAD_H, SPREAD_H),
				randf_range(0.0, SPREAD_V),
				randf_range(-SPREAD_H, SPREAD_H)
			)
			add_random_shape(area_2d)
			add_child(area_2d)
			area_3d_nodes.append(area_2d)

	func _physics_process(delta: float) -> void:
		for i in area_3d_nodes.size():
			time_accum += delta
			area_3d_nodes[i].position += Vector3(sin(time_accum), 0.0, cos(time_accum)) * 4.0

	func add_random_shape(parent: CollisionObject3D) -> void:
		var r := randi() % shapes.size()
		var collision_shape := CollisionShape3D.new()
		collision_shape.shape = shapes[r]
		if visualize:
			var mesh_instance := MeshInstance3D.new()
			mesh_instance.mesh = meshes[r]
			parent.add_child(mesh_instance)
		parent.add_child(collision_shape)


func _init() -> void:
	test_physics = true
	test_idle = true


func benchmark_1000_area_3d() -> TestScene:
	return TestScene.new(2000, 1000, true)
