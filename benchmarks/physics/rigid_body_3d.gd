extends Benchmark

const VISUALIZE := true
const SPREAD_H := 20.0;
const SPREAD_V := 10.0;

var boundary_shape := WorldBoundaryShape3D.new()
var box_shape := BoxShape3D.new()
var sphere_shape := SphereShape3D.new()
var box_mesh := BoxMesh.new()
var sphere_mesh := SphereMesh.new()

func _init() -> void:
	test_physics = true
	test_idle = true


func setup_scene(create_body_func: Callable, unique_shape: bool, boundary: bool, num_shapes: int) -> Node3D:
	var scene_root := Node3D.new()

	if VISUALIZE:
		var camera := Camera3D.new()
		camera.position = Vector3(0.0, 20.0, 20.0)
		camera.rotate_x(-0.8)
		scene_root.add_child(camera)

	if boundary:
		var pit := StaticBody3D.new();
		pit.add_child(create_wall(Vector3(SPREAD_H, 0.0, 0.0), Vector3(0.0, 0.0, 0.2)))
		pit.add_child(create_wall(Vector3(0.0, 0.0, SPREAD_H), Vector3(-0.2, 0.0, 0.0)))
		pit.add_child(create_wall(Vector3(-SPREAD_H, 0.0, 0.0), Vector3(0.0, 0.0, -0.2)))
		pit.add_child(create_wall(Vector3(0.0, 0.0, -SPREAD_H), Vector3(0.2, 0.0, 0.0)))
		scene_root.add_child(pit);

	for _i in num_shapes:
		var box: RigidBody3D = create_body_func.call(unique_shape)
		box.position = Vector3(randf_range(-SPREAD_H, SPREAD_H), randf_range(0.0, SPREAD_V), randf_range(-SPREAD_H, SPREAD_H))
		scene_root.add_child(box)

	return scene_root


func create_wall(position: Vector3, rotation: Vector3) -> CollisionShape3D:
	var wall := CollisionShape3D.new()
	wall.shape = boundary_shape
	wall.position = position
	wall.rotation = rotation
	return wall


func create_box(unique_shape: bool) -> RigidBody3D:
	var rigid_body := RigidBody3D.new()
	var collision_shape := CollisionShape3D.new()

	if VISUALIZE:
		var mesh_instance := MeshInstance3D.new()
		mesh_instance.mesh = box_mesh
		rigid_body.add_child(mesh_instance)

	if unique_shape:
		collision_shape.shape = BoxShape3D.new()
	else:
		# Reuse existing shape.
		collision_shape.shape = box_shape
	rigid_body.add_child(collision_shape)

	return rigid_body


func create_sphere(unique_shape: bool) -> RigidBody3D:
	var rigid_body := RigidBody3D.new()
	var collision_shape := CollisionShape3D.new()

	if VISUALIZE:
		var mesh_instance := MeshInstance3D.new()
		mesh_instance.mesh = sphere_mesh
		rigid_body.add_child(mesh_instance)

	if unique_shape:
		collision_shape.shape = SphereShape3D.new()
	else:
		# Reuse existing shape.
		collision_shape.shape = sphere_shape
	rigid_body.add_child(collision_shape)

	return rigid_body


func benchmark_2000_rigid_body_3d_shared_box_shape() -> Node3D:
	return setup_scene(create_box, false, true, 2000)


func benchmark_2000_rigid_body_3d_unique_box_shape() -> Node3D:
	return setup_scene(create_box, true, true, 2000)


func benchmark_2000_rigid_body_3d_shared_sphere_shape() -> Node3D:
	return setup_scene(create_sphere, false, true, 2000)


func benchmark_2000_rigid_body_3d_unique_sphere_shape() -> Node3D:
	return setup_scene(create_sphere, true, true, 2000)
