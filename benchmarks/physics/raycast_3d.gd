extends Benchmark

const N_OF_RAYCASTS := 10_000
const N_OF_SHAPES := 2000
const SPREAD_H := 20.0

var space: RID
var bodies: Array[RID]
var shapes: Array[RID]


func _setup_scene() -> void:
	space = PhysicsServer3D.space_create()
	PhysicsServer3D.space_set_active(space, true)
	for i in N_OF_SHAPES:
		var body := PhysicsServer3D.body_create()
		var shape: RID
		var r := randi() % 3
		match r:
			0:
				shape = PhysicsServer3D.box_shape_create()
			1:
				shape = PhysicsServer3D.capsule_shape_create()
			2:
				shape = PhysicsServer3D.sphere_shape_create()
		PhysicsServer3D.body_add_shape(body, shape)
		shapes.append(shape)
		PhysicsServer3D.body_set_space(body, space)
		bodies.append(body)
		var transform := Transform3D()
		transform.origin = _rand_pos()
		PhysicsServer3D.body_set_state(body, PhysicsServer3D.BODY_STATE_TRANSFORM, transform)


func _cast_raycasts() -> void:
	var space_state := PhysicsServer3D.space_get_direct_state(space)
	for i in N_OF_RAYCASTS:
		var query := PhysicsRayQueryParameters3D.create(_rand_pos(), _rand_pos())
		space_state.intersect_ray(query)


func _clear_scene() -> void:
	for i in shapes.size():  # shapes and bodies should have the same size
		PhysicsServer3D.free_rid(shapes[i])
		PhysicsServer3D.free_rid(bodies[i])
	PhysicsServer3D.free_rid(space)


func _rand_pos() -> Vector3:
	return Vector3(randf_range(-SPREAD_H, SPREAD_H), 0.0, 0.0)


func benchmark_10_000_raycast_3d() -> void:
	_setup_scene()
	_cast_raycasts()
	_clear_scene()
