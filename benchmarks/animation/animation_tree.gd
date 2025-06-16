extends Benchmark


func _init() -> void:
	test_render_cpu = true
	test_render_gpu = true


func benchmark_animation_tree_quads() -> Node:
	return preload("res://supplemental/animation_tree.tscn").instantiate()
