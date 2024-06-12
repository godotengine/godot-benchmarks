extends Benchmark

const N_OF_RAYCASTS := 10_000
const N_OF_SHAPES := 2000

var space: RID
var bodies: Array[RID]
var shapes: Array[RID]

var viewport_size := Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)


func _setup_scene() -> void:
	space = PhysicsServer2D.space_create()
	PhysicsServer2D.space_set_active(space, true)
	for i in N_OF_SHAPES:
		var body := PhysicsServer2D.body_create()
		var shape: RID
		var r := randi() % 3
		match r:
			0:
				shape = PhysicsServer2D.rectangle_shape_create()
			1:
				shape = PhysicsServer2D.capsule_shape_create()
			2:
				shape = PhysicsServer2D.circle_shape_create()
		PhysicsServer2D.body_add_shape(body, shape)
		shapes.append(shape)
		PhysicsServer2D.body_set_space(body, space)
		bodies.append(body)
		var transform := Transform2D()
		transform.origin = _rand_pos()
		PhysicsServer2D.body_set_state(body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform)


func _cast_raycasts() -> void:
	var space_state := PhysicsServer2D.space_get_direct_state(space)
	for i in N_OF_RAYCASTS:
		var query := PhysicsRayQueryParameters2D.create(_rand_pos(), _rand_pos())
		space_state.intersect_ray(query)


func _clear_scene() -> void:
	for i in shapes.size():  # shapes and bodies should have the same size
		PhysicsServer2D.free_rid(shapes[i])
		PhysicsServer2D.free_rid(bodies[i])
	PhysicsServer2D.free_rid(space)


func _rand_pos() -> Vector2:
	return Vector2(randf_range(0.0, viewport_size.x), randf_range(0.0, viewport_size.y))


func benchmark_10_000_raycast_2d() -> void:
	_setup_scene()
	_cast_raycasts()
	_clear_scene()
