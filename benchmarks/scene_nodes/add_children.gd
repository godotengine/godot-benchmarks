extends Benchmark

const ITERATIONS = 50_000

# Benchmark add_child by:
# 1) Adding ITERATIONS children nodes without name
# 2) Adding ITERATIONS children nodes with the same name

func benchmark_add_children_without_name() -> void:
	var root := Node.new()
	for i in ITERATIONS:
		root.add_child(Node.new())


func benchmark_add_children_with_same_name() -> void:
	var root := Node.new()
	for i in ITERATIONS:
		var node := Node.new()
		node.set_name("name")
		root.add_child(node)
