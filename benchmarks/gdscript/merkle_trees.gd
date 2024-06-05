extends Benchmark

# Ported from
# https://github.com/hanabi1224/Programming-Language-Benchmarks/blob/main/bench/algorithm/merkletrees/1.lua


class TreeNode:
	var value := -1
	var left: TreeNode
	var right: TreeNode
	var hash_i := -1  # Named that way so it doesn't conflict with the hash method

	func _init(_value: int, _left: TreeNode, _right: TreeNode) -> void:
		value = _value
		left = _left
		right = _right
		hash_i = -1

	func check() -> bool:
		if hash_i != -1:
			if value != -1:
				return true
			if left and right:
				return left.check() and right.check()
		return false

	func cal_hash() -> void:
		if hash_i == -1:
			if value != -1:
				hash_i = value
			elif left and right:
				left.cal_hash()
				right.cal_hash()
				hash_i = left.hash_i + right.hash_i


func make_tree(depth: int) -> TreeNode:
	if depth > 0:
		depth -= 1
		return TreeNode.new(-1, make_tree(depth), make_tree(depth))
	return TreeNode.new(1, null, null)


func calculate_merkle_trees(n: int) -> void:
	var min_depth := 4
	var max_depth := maxi(min_depth + 2, n)
	var stretch_depth := max_depth + 1
	var stretch_tree := make_tree(stretch_depth)
	stretch_tree.cal_hash()
	print(
		"stretch tree of depth {0}\t root hash: {1} check: {2}".format(
			[stretch_depth, stretch_tree.hash_i, stretch_tree.check()]
		)
	)

	var long_lived_tree := make_tree(max_depth)
	var max_plus_min_depth := max_depth + min_depth
	for depth in range(min_depth, max_depth, 2):
		var iterations := pow(2, max_plus_min_depth - depth)
		var sum := 0
		for i in iterations:
			var tree := make_tree(depth)
			tree.cal_hash()
			sum += tree.hash_i
		print("{0}\t trees of depth {1}\t root hash sum: {2}".format([iterations, depth, sum]))
	long_lived_tree.cal_hash()
	print(
		"long lived tree of depth {0}\t root hash: {1} check: {2}".format(
			[n, long_lived_tree.hash_i, long_lived_tree.check()]
		)
	)


func benchmark_merkle_trees_13() -> void:
	calculate_merkle_trees(13)


func benchmark_merkle_trees_15() -> void:
	calculate_merkle_trees(15)
