extends Benchmark

const SPEED := 300.0
const JUMP_VELOCITY := -400.0


class TestScene:
	extends Node2D

	var tile_map_scene := preload("res://supplemental/tilemap_scene.tscn")
	var tile_map_node: Node2D
	var n_of_character_bodies: int
	var visualize := true
	var character_bodies: Array[CharacterBody2D] = []
	var capsule_mesh := CapsuleMesh.new()
	var window_size: Vector2i

	func _init(_n_of_character_bodies: int, _visualize: bool) -> void:
		n_of_character_bodies = _n_of_character_bodies
		visualize = _visualize
		capsule_mesh.radius = 10.0
		capsule_mesh.height = 28.0

	func _ready() -> void:
		window_size = get_window().size
		tile_map_node = tile_map_scene.instantiate()
		add_child(tile_map_node)
		for i in n_of_character_bodies:
			var body := CharacterBody2D.new()
			body.position = Vector2(
				randf_range(0.0, window_size.x), randf_range(0.0, window_size.y)
			)
			var collision_shape := CollisionShape2D.new()
			collision_shape.shape = CapsuleShape2D.new()
			body.add_child(collision_shape)
			if visualize:
				var mesh_instance := MeshInstance2D.new()
				mesh_instance.mesh = capsule_mesh
				body.add_child(mesh_instance)
			tile_map_node.add_child(body)
			character_bodies.append(body)

	func _physics_process(delta: float) -> void:
		for body in character_bodies:
			if not body.is_on_floor():
				body.velocity += body.get_gravity() * delta

			if body.is_on_floor():
				body.velocity.y = JUMP_VELOCITY

			var direction := randf_range(-1.0, 1.0)
			if direction:
				body.velocity.x = direction * SPEED
			else:
				body.velocity.x = move_toward(body.velocity.x, 0, SPEED)

			body.move_and_slide()


func _init() -> void:
	test_physics = true
	test_idle = true


func benchmark_1000_character_bodies_2d() -> TestScene:
	return TestScene.new(1000, true)
