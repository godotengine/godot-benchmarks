extends Benchmark

const ITERATIONS = 2_000_000

# Benchmark various array types by:
# 1) Inserting ITERATIONS elements from the back
# 2) Updating all ITERATIONS elements
# 3) Popping all ITERATIONS elements from the front (non-constant complexity)

func benchmark_packed_int32_array() -> void:
	var array := PackedInt32Array()
	for i in ITERATIONS:
		array.push_back(i)
	for i in ITERATIONS:
		array[i] = 0
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_packed_int64_array() -> void:
	var array := PackedInt64Array()
	for i in ITERATIONS:
		array.push_back(i)
	for i in ITERATIONS:
		array[i] = 0
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_typed_int_array() -> void:
	var array: Array[int] = []
	for i in ITERATIONS:
		array.push_back(i)
	for i in ITERATIONS:
		array[i] = 0
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_untyped_int_array() -> void:
	var array = []
	for i in ITERATIONS:
		array.push_back(i)
	for i in ITERATIONS:
		array[i] = 0
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_packed_float32_array() -> void:
	var array := PackedFloat32Array()
	for i in ITERATIONS:
		array.push_back(i)
	for i in ITERATIONS:
		array[i] = 0.0
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_packed_float64_array() -> void:
	var array := PackedFloat64Array()
	for i in ITERATIONS:
		array.push_back(i)
	for i in ITERATIONS:
		array[i] = 0.0
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_typed_float_array() -> void:
	var array: Array[float] = []
	for i in ITERATIONS:
		array.push_back(i)
	for i in ITERATIONS:
		array[i] = 0.0
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_untyped_float_array() -> void:
	var array = []
	for i in ITERATIONS:
		array.push_back(i)
	for i in ITERATIONS:
		array[i] = 0.0
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_packed_vector2_array() -> void:
	var array := PackedVector2Array()
	for i in ITERATIONS:
		array.push_back(Vector2(i, i))
	for i in ITERATIONS:
		array[i] = Vector2.ZERO
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_typed_vector2_array() -> void:
	var array: Array[Vector2] = []
	for i in ITERATIONS:
		array.push_back(Vector2(i, i))
	for i in ITERATIONS:
		array[i] = Vector2.ZERO
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_untyped_vector2_array() -> void:
	var array = []
	for i in ITERATIONS:
		array.push_back(Vector2(i, i))
	for i in ITERATIONS:
		array[i] = Vector2.ZERO
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_packed_vector3_array() -> void:
	var array := PackedVector3Array()
	for i in ITERATIONS:
		array.push_back(Vector3(i, i, i))
	for i in ITERATIONS:
		array[i] = Vector3.ZERO
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_typed_vector3_array() -> void:
	var array: Array[Vector3] = []
	for i in ITERATIONS:
		array.push_back(Vector3(i, i, i))
	for i in ITERATIONS:
		array[i] = Vector3.ZERO
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_untyped_vector3_array() -> void:
	var array = []
	for i in ITERATIONS:
		array.push_back(Vector3(i, i, i))
	for i in ITERATIONS:
		array[i] = Vector3.ZERO
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_packed_color_array() -> void:
	var array := PackedColorArray()
	for i in ITERATIONS:
		array.push_back(Color(i, i, i, 1.0))
	for i in ITERATIONS:
		array[i] = Color.BLACK
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_typed_color_array() -> void:
	var array: Array[Color] = []
	for i in ITERATIONS:
		array.push_back(Color(i, i, i, 1.0))
	for i in ITERATIONS:
		array[i] = Color.BLACK
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_untyped_color_array() -> void:
	var array = []
	for i in ITERATIONS:
		array.push_back(Color(i, i, i, 1.0))
	for i in ITERATIONS:
		array[i] = Color.BLACK
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_packed_string_array() -> void:
	var array := PackedStringArray()
	for i in ITERATIONS:
		array.push_back(str("Godot ", i))
	for i in ITERATIONS:
		array[i] = ""
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_typed_string_array() -> void:
	var array: Array[String] = []
	for i in ITERATIONS:
		array.push_back(str("Godot ", i))
	for i in ITERATIONS:
		array[i] = ""
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_untyped_string_array() -> void:
	var array = []
	for i in ITERATIONS:
		array.push_back(str("Godot ", i))
	for i in ITERATIONS:
		array[i] = ""
	for i in ITERATIONS:
		array.remove_at(array.size() - 1)


func benchmark_fill_loop() -> void:
	var array = []
	array.resize(10_000_000)
	for i in array.size():
		array[i] = 1234


func benchmark_fill_method() -> void:
	var array = []
	array.resize(10_000_000)
	array.fill(1234)
