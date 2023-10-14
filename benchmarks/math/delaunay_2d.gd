extends Benchmark

const NUM_POINTS := 7_000
const UPPER_LEFT := Vector2(0.0, 0.0)
const BOTTOM_RIGHT := Vector2(10.0, 10.0)

var rng := RandomNumberGenerator.new()

func scatter_points(num_points: int,
					upper_left: Vector2,
					bottom_right: Vector2) -> PackedVector2Array:
	rng.seed = hash("Delaunay2D")
	var points := PackedVector2Array()

	for i in range(num_points):
		points.append(Vector2(
			rng.randf_range(upper_left.x, bottom_right.x),
			rng.randf_range(upper_left.y, bottom_right.y)
		))

	return points

var scattered_points := scatter_points(NUM_POINTS, UPPER_LEFT, BOTTOM_RIGHT)

func benchmark_delaunay2D() -> void:
	Geometry2D.triangulate_delaunay(scattered_points)
