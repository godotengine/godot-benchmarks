extends Benchmark

const ITERATIONS = 50_000

var roots: Array[Node] = [ null, null, null ]
var children: Array[Array] = [ [], [], [] ]

# Benchmark remove_child by:
# 1) Removing ITERATIONS children nodes in order
# 2) Removing ITERATIONS children nodes in reverse order
# 3) Removing ITERATIONS children nodes in random order
# The different root-children pairs are stored in arrays since they need to be
# created before the benchmark calls. Thus, the benchmarks use these pair indexes.
# All trees are created in init.

func _init() -> void:
	create_trees()
	children[1].reverse()
	children[2].shuffle()


func create_trees() -> void:
	for i in roots.size():
		roots[i] = Node.new()
		for j in ITERATIONS:
			roots[i].add_child(Node.new())
		children[i] = roots[i].get_children()


func benchmark_delete_children_in_order() -> void:
	remove_children(0)


func benchmark_delete_children_reverse_order() -> void:
	remove_children(1)


func benchmark_delete_children_random_order() -> void:
	remove_children(2)


func remove_children(idx: int) -> void:
	var root := roots[idx]
	var nodes := children[idx]
	for i in ITERATIONS:
		root.remove_child(nodes[i])
