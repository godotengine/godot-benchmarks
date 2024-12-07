#include "array.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void CPPBenchmarkArray::_bind_methods() {
	ClassDB::bind_method(D_METHOD("benchmark_fill_loop"), &CPPBenchmarkArray::benchmark_fill_loop);
	ClassDB::bind_method(D_METHOD("benchmark_int32_array"), &CPPBenchmarkArray::benchmark_int32_array);
	ClassDB::bind_method(D_METHOD("benchmark_int64_array"), &CPPBenchmarkArray::benchmark_int64_array);
	ClassDB::bind_method(D_METHOD("benchmark_float32_array"), &CPPBenchmarkArray::benchmark_float32_array);
	ClassDB::bind_method(D_METHOD("benchmark_float64_array"), &CPPBenchmarkArray::benchmark_float64_array);
	ClassDB::bind_method(D_METHOD("benchmark_vector2_array"), &CPPBenchmarkArray::benchmark_vector2_array);
	ClassDB::bind_method(D_METHOD("benchmark_vector3_array"), &CPPBenchmarkArray::benchmark_vector3_array);
	ClassDB::bind_method(D_METHOD("benchmark_vector4_array"), &CPPBenchmarkArray::benchmark_vector4_array);
	ClassDB::bind_method(D_METHOD("benchmark_color_array"), &CPPBenchmarkArray::benchmark_color_array);
	ClassDB::bind_method(D_METHOD("benchmark_string_array"), &CPPBenchmarkArray::benchmark_string_array);
}

void CPPBenchmarkArray::benchmark_fill_loop() {
	constexpr int length = 10000000;
	int array[length];
	for (int i = 0; i < length; i++) {
		array[i] = 1234;
	}
}

void CPPBenchmarkArray::benchmark_int32_array() {
	TypedArray<int32_t> array;

	for (int i = 0; i < iterations; i++)
		array.push_back(i);

	for (int i = 0; i < iterations; i++)
		array[i] = 0;

	for (int i = 0; i < iterations; i++)
		array.remove_at(array.size() - 1);
}

void CPPBenchmarkArray::benchmark_int64_array() {
	TypedArray<int64_t> array;

	for (int i = 0; i < iterations; i++)
		array.push_back(i);

	for (int i = 0; i < iterations; i++)
		array[i] = 0;

	for (int i = 0; i < iterations; i++)
		array.remove_at(array.size() - 1);
}

void CPPBenchmarkArray::benchmark_float32_array() {
	TypedArray<float> array;

	for (int i = 0; i < iterations; i++)
		array.push_back(i);

	for (int i = 0; i < iterations; i++)
		array[i] = 0.0;

	for (int i = 0; i < iterations; i++)
		array.remove_at(array.size() - 1);
}

void CPPBenchmarkArray::benchmark_float64_array() {
	TypedArray<double> array;

	for (int i = 0; i < iterations; i++)
		array.push_back(i);

	for (int i = 0; i < iterations; i++)
		array[i] = 0.0;

	for (int i = 0; i < iterations; i++)
		array.remove_at(array.size() - 1);
}

void CPPBenchmarkArray::benchmark_vector2_array() {
	TypedArray<Vector2> array;

	for (int i = 0; i < iterations; i++)
		array.push_back(Vector2(i, i));

	for (int i = 0; i < iterations; i++)
		array[i] = Vector2(0, 0);

	for (int i = 0; i < iterations; i++)
		array.remove_at(array.size() - 1);
}

void CPPBenchmarkArray::benchmark_vector3_array() {
	TypedArray<Vector3> array;

	for (int i = 0; i < iterations; i++)
		array.push_back(Vector3(i, i, i));

	for (int i = 0; i < iterations; i++)
		array[i] = Vector3(0, 0, 0);

	for (int i = 0; i < iterations; i++)
		array.remove_at(array.size() - 1);
}

void CPPBenchmarkArray::benchmark_vector4_array() {
	TypedArray<Vector4> array;

	for (int i = 0; i < iterations; i++)
		array.push_back(Vector4(i, i, i, i));

	for (int i = 0; i < iterations; i++)
		array[i] = Vector4(0, 0, 0, 0);

	for (int i = 0; i < iterations; i++)
		array.remove_at(array.size() - 1);
}

void CPPBenchmarkArray::benchmark_color_array() {
	TypedArray<Color> array;

	for (int i = 0; i < iterations; i++)
		array.push_back(Color(i, i, i, 1.0));

	for (int i = 0; i < iterations; i++)
		array[i] = Color(0, 0, 0, 0);

	for (int i = 0; i < iterations; i++)
		array.remove_at(array.size() - 1);
}

void CPPBenchmarkArray::benchmark_string_array() {
	TypedArray<String> array;

	for (int64_t i = 0; i < iterations; i++) // i needs to be int64_t for string formatting to work, as the String::% operator is not overloaded for int
		array.push_back(String("Godot %d") % i);

	for (int i = 0; i < iterations; i++)
		array[i] = "";

	for (int i = 0; i < iterations; i++)
		array.remove_at(array.size() - 1);
}

CPPBenchmarkArray::CPPBenchmarkArray() {}

CPPBenchmarkArray::~CPPBenchmarkArray() {}
