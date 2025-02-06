extends Benchmark


func _init() -> void:
	test_render_cpu = true
	test_render_gpu = true


func benchmark_skeleton_3d() -> Node:
	return preload("res://supplemental/skeletal.tscn").instantiate()

func benchmark_skeleton_3d_no_skeleton() -> Node:
	return preload("res://supplemental/non_skeletal.tscn").instantiate()
