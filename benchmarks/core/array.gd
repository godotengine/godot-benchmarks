extends Benchmark

static func create_array(size: int) -> Array[int]:
	var result : Array[int] = []
	result.resize(size)
	for i: int in size:
		result[i] = i
	return result

# Creating the `ref` arrays triggers copy-on-write

const ITERATIONS = 1_000_000

var array_10 := create_array(10)
var array_ref_10 := array_10

var array_100 := create_array(100)
var array_ref_100 := array_100

func benchmark_reverse() -> void:
	for i in ITERATIONS:
		array_10.reverse()

func benchmark_bsearch() -> void:
	for i in ITERATIONS:
		var index := array_10.bsearch(array_10[i % array_10.size()])
		assert(index != -1, "Invalid index could have unexpected results.")

func benchmark_append_array() -> void:
	for i in ITERATIONS:
		array_100.append_array(array_10)

func benchmark_fill() -> void:
	for i in ITERATIONS:
		array_10.fill(100 + i)
