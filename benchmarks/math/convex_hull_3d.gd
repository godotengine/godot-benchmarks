extends Benchmark

const NUM_ITERATIONS := 10
const NUM_POINTS := 1002  # Should be a multiple of three, triangles will be built with this.
const CLOUD_SIZE := 1.0
const POSITION := Vector3(0.0, 0.0, 0.0)

func generate_point_cloud(size: float, num_points: int, position: Vector3) -> PackedVector3Array:
	var points := PackedVector3Array()
	for _i in num_points:
		var point = position + Vector3(
			randf_range(-size, size),
			randf_range(-size, size),
			randf_range(-size, size),
		)
		points.append(point)
	return points


func mesh_with_vertices(vertices: PackedVector3Array) -> Mesh:
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices

	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	return arr_mesh

func _bench_convex(clean: bool, simplify: bool) -> void:
	for i in NUM_ITERATIONS:
		var points := generate_point_cloud(CLOUD_SIZE, NUM_POINTS, POSITION)
		var mesh := mesh_with_vertices(points)
		var convex := mesh.create_convex_shape(clean, simplify)

func benchmark_both_clean_and_simplify() -> void:
	return _bench_convex(true, true)

func benchmark_only_clean() -> void:
	return _bench_convex(false, true)

func benchmark_only_simplify() -> void:
	return _bench_convex(true, false)

func benchmark_quickest() -> void:
	return _bench_convex(false, false)
