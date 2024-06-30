extends Benchmark

const SPREAD_H := 1600.0;
const SPREAD_V := 800.0;

var boundary_shape := WorldBoundaryShape2D.new()
var square_shape := RectangleShape2D.new()
var circle_shape := CircleShape2D.new()
var square_mesh := QuadMesh.new()
var circle_mesh := SphereMesh.new()

func _init() -> void:
	square_mesh.size = Vector2(20.0, 20.0);
	circle_mesh.radius = 10.0;
	circle_mesh.height = 20.0;
	benchmark_time = 10e6
	test_physics = true
	test_idle = true


func setup_scene(create_body_func: Callable, unique_shape: bool, ccd_mode: RigidBody2D.CCDMode, boundary: bool, num_shapes: int) -> Node2D:
	var scene_root := Node2D.new()

	if Manager.visualize:
		var camera := Camera2D.new()
		camera.position = Vector2(0.0, -100.0)
		camera.zoom = Vector2(0.5, 0.5)
		scene_root.add_child(camera)

	if boundary:
		var pit := StaticBody2D.new();
		pit.add_child(create_wall(Vector2(SPREAD_H, 0.0), -0.1))
		pit.add_child(create_wall(Vector2(-SPREAD_H, 0.0), 0.1))
		scene_root.add_child(pit);

	for _i in num_shapes:
		var body: RigidBody2D = create_body_func.call(unique_shape, ccd_mode)
		body.position = Vector2(randf_range(-SPREAD_H, SPREAD_H), randf_range(0.0, -SPREAD_V))
		scene_root.add_child(body)

	return scene_root


func create_wall(position: Vector2, rotation: float) -> CollisionShape2D:
	var wall := CollisionShape2D.new()
	wall.shape = boundary_shape
	wall.position = position
	wall.rotation = rotation
	return wall


func create_random_shape(unique_shape: bool, ccd_mode: RigidBody2D.CCDMode) -> RigidBody2D:
	match randi_range(0, 1):
		0: return create_square(unique_shape, ccd_mode)
		_: return create_circle(unique_shape, ccd_mode)


func create_square(unique_shape: bool, ccd_mode: RigidBody2D.CCDMode) -> RigidBody2D:
	var rigid_body := RigidBody2D.new()
	var collision_shape := CollisionShape2D.new()
	rigid_body.continuous_cd = ccd_mode

	if Manager.visualize:
		var mesh_instance := MeshInstance2D.new()
		mesh_instance.mesh = square_mesh
		rigid_body.add_child(mesh_instance)

	if unique_shape:
		collision_shape.shape = RectangleShape2D.new()
	else:
		# Reuse existing shape.
		collision_shape.shape = square_shape
	rigid_body.add_child(collision_shape)

	return rigid_body


func create_circle(unique_shape: bool, ccd_mode: RigidBody2D.CCDMode) -> RigidBody2D:
	var rigid_body := RigidBody2D.new()
	var collision_shape := CollisionShape2D.new()
	rigid_body.continuous_cd = ccd_mode

	if Manager.visualize:
		var mesh_instance := MeshInstance2D.new()
		mesh_instance.mesh = circle_mesh
		rigid_body.add_child(mesh_instance)

	if unique_shape:
		collision_shape.shape = CircleShape2D.new()
	else:
		# Reuse existing shape.
		collision_shape.shape = circle_shape
	rigid_body.add_child(collision_shape)

	return rigid_body


func benchmark_2000_rigid_body_2d_squares() -> Node2D:
	return setup_scene(create_square, false, RigidBody2D.CCD_MODE_DISABLED, true, 2000)


func benchmark_2000_rigid_body_2d_circles() -> Node2D:
	return setup_scene(create_circle, false, RigidBody2D.CCD_MODE_DISABLED, true, 2000)


func benchmark_2000_rigid_body_2d_mixed() -> Node2D:
	return setup_scene(create_random_shape, false, RigidBody2D.CCD_MODE_DISABLED, true, 2000)


func benchmark_2000_rigid_body_2d_unique() -> Node2D:
	return setup_scene(create_random_shape, true, RigidBody2D.CCD_MODE_DISABLED, true, 2000)


func benchmark_2000_rigid_body_2d_continuous() -> Node2D:
	return setup_scene(create_random_shape, false, RigidBody2D.CCD_MODE_CAST_SHAPE, true, 2000)


func benchmark_2000_rigid_body_2d_unbound() -> Node2D:
	return setup_scene(create_random_shape, false, RigidBody2D.CCD_MODE_DISABLED, false, 2000)
