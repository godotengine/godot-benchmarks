#ifndef CPP_BENCHMARK_ALLOC_H
#define CPP_BENCHMARK_ALLOC_H

#include "../cppbenchmark.h"

namespace godot {

class CPPBenchmarkAlloc : public CPPBenchmark {
	GDCLASS(CPPBenchmarkAlloc, CPPBenchmark)

protected:
	static void _bind_methods();

public:
	unsigned int iterations = 100000;
	void benchmark_deep_tree();
	void benchmark_wide_tree();
	void benchmark_fragmentation();
	void benchmark_duplicate();

	CPPBenchmarkAlloc();
	~CPPBenchmarkAlloc();
};

} // namespace godot

#endif
