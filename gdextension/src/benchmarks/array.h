#ifndef CPP_BENCHMARK_ARRAY_H
#define CPP_BENCHMARK_ARRAY_H

#include "../cppbenchmark.h"

namespace godot {

class CPPBenchmarkArray : public CPPBenchmark {
	GDCLASS(CPPBenchmarkArray, CPPBenchmark)

protected:
	static void _bind_methods();

public:
	unsigned int iterations = 2000000;
	void benchmark_fill_loop();
	void benchmark_int32_array();
	void benchmark_int64_array();
	void benchmark_float32_array();
	void benchmark_float64_array();
	void benchmark_vector2_array();
	void benchmark_vector3_array();
	void benchmark_vector4_array();
	void benchmark_color_array();
	void benchmark_string_array();

	CPPBenchmarkArray();
	~CPPBenchmarkArray();
};

} // namespace godot

#endif
