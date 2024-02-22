extends Benchmark

const NUM_POINTS := 1_000
const UPPER_LEFT_DOWN := Vector3(0.0, 0.0, 0.0)
const BOTTOM_RIGHT_UP := Vector3(10.0, 10.0, 10.0)

var rng := RandomNumberGenerator.new()

func scatter_points_3D(num_points: int,
					   upper_left_down: Vector3,
					   bottom_right_up: Vector3) -> PackedVector3Array:
	rng.seed = hash("Delaunay3D")
	var points := PackedVector3Array()

	for i in range(num_points):
		points.append(Vector3(
			rng.randf_range(upper_left_down.x, bottom_right_up.x),
			rng.randf_range(upper_left_down.y, bottom_right_up.y),
			rng.randf_range(upper_left_down.z, bottom_right_up.z)
		))

	return points

var scattered_points := scatter_points_3D(NUM_POINTS, UPPER_LEFT_DOWN, BOTTOM_RIGHT_UP)

func benchmark_delaunay3D() -> void:
	Geometry3D.tetrahedralize_delaunay(scattered_points)
