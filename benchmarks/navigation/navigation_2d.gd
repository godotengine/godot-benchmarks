extends Benchmark

const NAVPOLYGON := preload("res://supplemental/navigation_polygon.res")
const SPREAD_H := 680.0
const SPREAD_V := 540.0


func calculate_navigation_path(n_of_paths: int) -> void:
	var map := NavigationServer2D.map_create()
	NavigationServer2D.map_set_active(map, true)
	NavigationServer2D.map_set_cell_size(map, 1.0)
	var region := NavigationServer2D.region_create()
	NavigationServer2D.region_set_navigation_polygon(region, NAVPOLYGON)
	NavigationServer2D.region_set_map(region, map)
	NavigationServer2D.map_force_update(map)
	for i in n_of_paths:
		NavigationServer2D.map_get_path(map, _rand_pos(), _rand_pos(), false)
	NavigationServer2D.free_rid(region)
	NavigationServer2D.free_rid(map)


func _rand_pos() -> Vector2:
	return Vector2(randf_range(0.0, SPREAD_H), randf_range(0.0, SPREAD_V))


func benchmark_navigation_10_000_random_paths() -> void:
	calculate_navigation_path(10_000)
