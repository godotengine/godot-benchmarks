extends Benchmark

const RADIUS := 1.0
const NUM_SIDES := 7_000
const POSITION := Vector2(0.0, 0.0)

func generate_circle_polygon(radius: float,
							 num_sides: int,
							 position: Vector2) -> PackedVector2Array:
	var angle_delta: float = (PI * 2) / num_sides
	var vector: Vector2 = Vector2(radius, 0)
	var polygon := PackedVector2Array()

	for _i in num_sides:
		polygon.append(vector + position)
		vector = vector.rotated(angle_delta)

	return polygon

var circle := generate_circle_polygon(RADIUS, NUM_SIDES, POSITION)

func benchmark_triangulate() -> void:
	Geometry2D.triangulate_polygon(circle)
