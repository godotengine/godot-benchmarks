extends Benchmark

const UPPER_LEFT_DOWN := Vector3(0.0, 0.0, 0.0)
const BOTTOM_RIGHT_UP := Vector3(10.0, 10.0, 10.0)


func add_points(n_of_points: int, astar: AStar3D) -> PackedVector3Array:
	var points := PackedVector3Array()
	for i in n_of_points:
		var point := Vector3(
			randf_range(UPPER_LEFT_DOWN.x, BOTTOM_RIGHT_UP.x),
			randf_range(UPPER_LEFT_DOWN.y, BOTTOM_RIGHT_UP.y),
			randf_range(UPPER_LEFT_DOWN.z, BOTTOM_RIGHT_UP.z)
		)
		points.append(point)
		astar.add_point(i, point)
	return points


func connect_points(points: PackedVector3Array, astar: AStar3D) -> void:
	var connected_points := Geometry3D.tetrahedralize_delaunay(points)
	for i in range(0, connected_points.size() - 4, 4):
		var point1 := connected_points[i]
		var point2 := connected_points[i + 1]
		var point3 := connected_points[i + 2]
		var point4 := connected_points[i + 3]
		astar.connect_points(point1, point2)
		astar.connect_points(point1, point3)
		astar.connect_points(point1, point4)
		astar.connect_points(point2, point3)
		astar.connect_points(point2, point4)
		astar.connect_points(point3, point4)


func solve_astar(n_of_times: int, n_of_points: int) -> void:
	var astar := AStar3D.new()
	var points := add_points(n_of_points, astar)
	connect_points(points, astar)
	for i in n_of_times:
		var point1 := randi() % n_of_points
		var point2 := randi() % n_of_points
		astar.get_point_path(point1, point2)


func benchmark_astar_3d_1000_times_1000_points() -> void:
	solve_astar(1000, 1000)
