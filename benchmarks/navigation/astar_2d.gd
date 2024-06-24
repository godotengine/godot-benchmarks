extends Benchmark

const UPPER_LEFT_DOWN := Vector2(0.0, 0.0)
const BOTTOM_RIGHT_UP := Vector2(10.0, 10.0)


func add_points(n_of_points: int, astar: AStar2D) -> PackedVector2Array:
	var points := PackedVector2Array()
	for i in n_of_points:
		var point := Vector2(
			randf_range(UPPER_LEFT_DOWN.x, BOTTOM_RIGHT_UP.x),
			randf_range(UPPER_LEFT_DOWN.y, BOTTOM_RIGHT_UP.y),
		)
		points.append(point)
		astar.add_point(i, point)
	return points


func connect_points(points: PackedVector2Array, astar: AStar2D) -> void:
	var connected_points := Geometry2D.triangulate_delaunay(points)
	for i in range(0, connected_points.size() - 3, 3):
		var point1 := connected_points[i]
		var point2 := connected_points[i + 1]
		var point3 := connected_points[i + 2]
		astar.connect_points(point1, point2)
		astar.connect_points(point1, point3)
		astar.connect_points(point2, point3)


func solve_astar(n_of_times: int, n_of_points: int) -> void:
	var astar := AStar2D.new()
	var points := add_points(n_of_points, astar)
	connect_points(points, astar)
	for i in n_of_times:
		var point1 := randi() % n_of_points
		var point2 := randi() % n_of_points
		astar.get_point_path(point1, point2)


func benchmark_astar_5000_times_5000_points() -> void:
	solve_astar(5000, 5000)
