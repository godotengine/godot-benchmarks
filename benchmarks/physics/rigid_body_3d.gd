extends Benchmark

var box_shape := BoxShape3D.new()
var sphere_shape := SphereShape3D.new()

func _init() -> void:
	test_physics = true
	test_idle = true


func setup_scene(create_body_func: Callable, unique_shape: bool, num_shapes: int) -> Node3D:
	var scene_root := Node3D.new()
	var camera := Camera3D.new()
	camera.position.y = 0.3
	camera.position.z = 1.0
	camera.rotate_x(-0.8)
	scene_root.add_child(camera)

	for _i in num_shapes:
		var box: RigidBody3D = create_body_func.call(unique_shape)
		box.position.x = randf_range(-50, 50)
		box.position.z = randf_range(-50, 50)
		scene_root.add_child(box)

	return scene_root


func create_box(unique_shape: bool) -> RigidBody3D:
	var rigid_body := RigidBody3D.new()

	var collision_shape := CollisionShape3D.new()
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
	if unique_shape:
		collision_shape.shape = SphereShape3D.new()
	else:
		# Reuse existing shape.
		collision_shape.shape = sphere_shape
	rigid_body.add_child(collision_shape)

	return rigid_body


func benchmark_7500_rigid_body_3d_shared_box_shape() -> Node3D:
	return setup_scene(create_box, false, 7500)


func benchmark_7500_rigid_body_3d_unique_box_shape() -> Node3D:
	return setup_scene(create_box, true, 7500)


func benchmark_7500_rigid_body_3d_shared_sphere_shape() -> Node3D:
	return setup_scene(create_sphere, false, 7500)


func benchmark_7500_rigid_body_3d_unique_sphere_shape() -> Node3D:
	return setup_scene(create_sphere, true, 7500)
