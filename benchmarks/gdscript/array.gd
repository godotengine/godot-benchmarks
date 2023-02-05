extends Benchmark

const ITERATIONS = 80_000


# Benchmark various array types by:
# 1) Inserting ITERATIONS elements from the back
# 2) Updating all ITERATIONS elements
# 3) Popping all ITERATIONS elements from the front (non-constant complexity)

func benchmark_typed_int_array():
	var array: Array[int] = []
	for i in ITERATIONS:
		array.push_back(i)
	for i in ITERATIONS:
		array[i] = 0
	for i in ITERATIONS:
		array.remove_at(0)

func benchmark_untyped_int_array():
	var array = []
	for i in ITERATIONS:
		array.push_back(i)
	for i in ITERATIONS:
		array[i] = 0
	for i in ITERATIONS:
		array.remove_at(0)


func benchmark_packed_string_array():
	var array := PackedStringArray()
	for i in ITERATIONS:
		array.push_back(str("Godot ", i))
	for i in ITERATIONS:
		array[i] = ""
	for i in ITERATIONS:
		array.remove_at(0)

func benchmark_typed_string_array():
	var array: Array[String] = []
	for i in ITERATIONS:
		array.push_back(str("Godot ", i))
	for i in ITERATIONS:
		array[i] = ""
	for i in ITERATIONS:
		array.remove_at(0)

func benchmark_untyped_string_array():
	var array = []
	for i in ITERATIONS:
		array.push_back(str("Godot ", i))
	for i in ITERATIONS:
		array[i] = ""
	for i in ITERATIONS:
		array.remove_at(0)


