extends Benchmark

const ITERATIONS = 50_000

var root: Node
var node_paths: Array[NodePath]

# Benchmark get_node by calling it ITERATIONS times, once per node on tree.
# All node paths are relative to the root node.
# A random nesting tree is created in init.

func _init() -> void:
	root = Node.new()
	var nodes: Array[Node] = [root]
	for i in ITERATIONS:
		var new_node := Node.new()
		var random_parent := nodes[randi() % nodes.size()]
		random_parent.add_child(new_node)
		nodes.push_back(new_node)

	for node in nodes:
		node_paths.push_back(root.get_path_to(node))


func benchmark_get_node() -> void:
	for path in node_paths:
		root.get_node(path)
