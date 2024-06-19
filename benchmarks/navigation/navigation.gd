extends Benchmark

const NAVMESH := preload("res://supplemental/navmesh_sponza.tres")
const SPREAD_H := 20.0
const SPREAD_V := 10.0


func calculate_navigation_path(n_of_paths: int) -> void:
	var map := NavigationServer3D.map_create()
	NavigationServer3D.map_set_active(map, true)
	var region := NavigationServer3D.region_create()
	NavigationServer3D.region_set_navigation_mesh(region, NAVMESH)
	NavigationServer3D.region_set_map(region, map)
	NavigationServer3D.map_force_update(map)
	for i in n_of_paths:
		NavigationServer3D.map_get_path(map, _rand_pos(), _rand_pos(), false)
	NavigationServer3D.free_rid(region)
	NavigationServer3D.free_rid(map)


func _rand_pos() -> Vector3:
	return Vector3(
		randf_range(0.0, SPREAD_H),
		randf_range(0.0, SPREAD_V),
		randf_range(0.0, SPREAD_H)
	)


func benchmark_navigation_1000_random_paths() -> void:
	calculate_navigation_path(1000)
