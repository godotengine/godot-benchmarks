extends Benchmark

const SPEED := 30.0
const JUMP_VELOCITY := -40.0
const SPREAD_H := 32.0
const SPREAD_V := 20.0


class TestScene:
	extends Node3D

	var grid_map_scene := preload("res://supplemental/gridmap_scene.tscn")
	var grid_map_node: Node3D
	var n_of_character_bodies: int
	var visualize := true
	var character_bodies: Array[CharacterBody3D] = []
	var capsule_mesh := CapsuleMesh.new()

	func _init(_n_of_character_bodies: int, _visualize: bool) -> void:
		n_of_character_bodies = _n_of_character_bodies
		visualize = _visualize

	func _ready() -> void:
		grid_map_node = grid_map_scene.instantiate()
		add_child(grid_map_node)
		for i in n_of_character_bodies:
			var body := CharacterBody3D.new()
			body.position = Vector3(
				randf_range(-SPREAD_H, SPREAD_H), randf_range(-SPREAD_V, SPREAD_V), 0.0
			)
			body.axis_lock_linear_z = true
			var collision_shape := CollisionShape3D.new()
			collision_shape.shape = CapsuleShape3D.new()
			body.add_child(collision_shape)
			if visualize:
				var mesh_instance := MeshInstance3D.new()
				mesh_instance.mesh = capsule_mesh
				body.add_child(mesh_instance)
			grid_map_node.add_child(body)
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


func benchmark_1000_character_bodies_3d() -> TestScene:
	return TestScene.new(1000, true)
