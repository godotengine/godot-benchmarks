extends Benchmark


func bottom_up_tree(depth: int) -> Array:
	if depth > 0:
		depth -= 1
		var left = bottom_up_tree(depth)[0]
		var right = bottom_up_tree(depth)[1]
		return [left, right]
	return [null, null]


func item_check(tree: Array) -> int:
	if tree[1]:
		return 1 + item_check(tree[0]) + item_check(tree[1])
	return 1


func calculate_binary_trees(n: int) -> void:
	var min_depth := 4
	var max_depth := maxi(min_depth + 2, n)
	var stretch_depth := max_depth + 1
	var stretch_tree := bottom_up_tree(stretch_depth)
	print(
		"stretch tree of depth {0}\t check: {1}".format([stretch_depth, item_check(stretch_tree)])
	)

	var long_lived_tree := bottom_up_tree(max_depth)
	var max_plus_min_depth := max_depth + min_depth
	for depth in range(min_depth, max_depth, 2):
		var iterations := pow(2, max_plus_min_depth - depth)
		var check := 0
		for i in iterations:
			check += item_check(bottom_up_tree(depth))
		print("{0}\t trees of depth {1}\t check: {2}".format([iterations, depth, check]))
	print(
		"long lived tree of depth {0}\t check: {1}".format([max_depth, item_check(long_lived_tree)])
	)


func benchmark_binary_trees_15() -> void:
	calculate_binary_trees(15)


func benchmark_binary_trees_18() -> void:
	calculate_binary_trees(18)
