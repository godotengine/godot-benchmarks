extends Benchmark


class TestScene:
	extends Node2D

	var num_character_bodies: int
	var num_area_2d: int
	var visualize := true
	var area_2d_nodes: Array[Area2D]
	var window_size: Vector2i
	var time_accum := 0.0
	var shapes: Array[Shape2D] = [
		RectangleShape2D.new(),
		CapsuleShape2D.new(),
		CircleShape2D.new(),
	]
	var meshes: Array[Mesh] = [
		QuadMesh.new(),
		CapsuleMesh.new(),
		SphereMesh.new(),
	]

	func _init(_num_character_bodies: int, _num_area_2d: int, _visualize: bool) -> void:
		num_character_bodies = _num_character_bodies
		num_area_2d = _num_area_2d
		visualize = _visualize

		meshes[0].size = Vector2(20.0, 20.0)
		meshes[1].radius = 10.0
		meshes[1].height = 28.0
		meshes[2].radius = 10.0
		meshes[2].height = 20.0

	func _ready() -> void:
		window_size = get_window().size
		for i in num_character_bodies:
			var character_body := CharacterBody2D.new()
			character_body.position = Vector2(
				randf_range(0.0, window_size.x), randf_range(0.0, window_size.y)
			)
			add_random_shape(character_body)
			add_child(character_body)

		for i in num_area_2d:
			var area_2d := Area2D.new()
			area_2d.position = Vector2(
				randf_range(0.0, window_size.x), randf_range(0.0, window_size.y)
			)
			add_random_shape(area_2d)
			add_child(area_2d)
			area_2d_nodes.append(area_2d)

	func _physics_process(delta: float) -> void:
		for i in area_2d_nodes.size():
			time_accum += delta
			area_2d_nodes[i].position += Vector2(sin(time_accum), cos(time_accum)) * 20.0

	func add_random_shape(parent: CollisionObject2D) -> void:
		var r := randi() % shapes.size()
		var collision_shape := CollisionShape2D.new()
		collision_shape.shape = shapes[r]
		if visualize:
			var mesh_instance := MeshInstance2D.new()
			mesh_instance.mesh = meshes[r]
			parent.add_child(mesh_instance)
		parent.add_child(collision_shape)


func _init() -> void:
	test_physics = true
	test_idle = true


func benchmark_1000_area_2d() -> TestScene:
	return TestScene.new(2000, 1000, true)
