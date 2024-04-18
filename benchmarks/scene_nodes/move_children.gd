extends Benchmark

# Moving children is much slower than other scene node operations,
# so perform fewer iterations to ensure it completes in a reasonable amount of time.
const ITERATIONS = 1_000

var root: Node
var children: Array[Node]

# Benchmark move_child by moving to random positions ITERATIONS 
# children ITERATIONS times. The tree is created in init.

func _init() -> void:
	root = Node.new()
	for i in ITERATIONS:
		root.add_child(Node.new())
	children = root.get_children()


func benchmark_move_children() -> void:
	var size := children.size()
	for node in children:
		for i in ITERATIONS:
			root.move_child(node, randi() % size)
