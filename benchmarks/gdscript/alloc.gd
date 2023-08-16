extends Benchmark

const ITERATIONS = 100_000


func benchmark_deep_tree() -> void:
	var rt := Node.new()
	for i in ITERATIONS:
		var n := Node.new()
		n.add_child(rt)
		rt = n

	# Avoid triggering a stack overflow with rt.free()
	while rt.get_child_count():
		var n := rt.get_child(0)
		rt.remove_child(n)
		rt.free()
		rt = n
	rt.free()

func benchmark_wide_tree() -> void:
	var rt := Node.new()
	for i in ITERATIONS:
		rt.add_child(Node.new())
	rt.free()

func benchmark_fragmentation() -> void:
	var top := Node.new()
	for i in 5:
		top.add_child(Node.new())

	for k in 10:
		for i in ITERATIONS:
			# Attempt to scatter children in memory by assigning newly created nodes to a random parent
			var idx := randi() % top.get_child_count()
			top.get_child(idx).add_child(Node.new())

		var tmp := top.get_child(0)
		top.remove_child(tmp)
		# Since nodes in the tree are scattered in memory,
		# freeing subtrees this way should maximize fragmentation.
		tmp.free()
		top.add_child(Node.new())
		#print("Iteration %d: %.3f MB" % [k, Performance.get_monitor(Performance.MEMORY_STATIC) / 1e6])

	top.free()

func benchmark_duplicate() -> void:
	var rt := Node.new()
	for i in 16:
		var n := Node.new()
		n.add_child(rt.duplicate())
		n.add_child(rt.duplicate())
		rt.free()
		rt = n
		#print("Iteration %d: %.3f MB" % [i, Performance.get_monitor(Performance.MEMORY_STATIC) / 1e6])
	rt.free()
