#ifndef CPP_BENCHMARK_ARRAY_OPS_H
#define CPP_BENCHMARK_ARRAY_OPS_H

#include "../cppbenchmark.h"

namespace godot {

class CPPBenchmarkArrayOps : public CPPBenchmark {
	GDCLASS(CPPBenchmarkArrayOps, CPPBenchmark)

protected:
	static void _bind_methods();

private:
	TypedArray<int64_t> array_10;
	TypedArray<int64_t> array_100;

public:
	unsigned int iterations = 1000000;

	void benchmark_reverse();
	void benchmark_bsearch();
	void benchmark_append_array();
	void benchmark_fill();

	CPPBenchmarkArrayOps();
	~CPPBenchmarkArrayOps();
};

} // namespace godot

#endif
