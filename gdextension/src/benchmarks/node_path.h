#ifndef CPP_BENCHMARK_NODE_PATH_H
#define CPP_BENCHMARK_NODE_PATH_H

#include "../cppbenchmark.h"

namespace godot {

class CPPBenchmarkNodePath : public CPPBenchmark {
	GDCLASS(CPPBenchmarkNodePath, CPPBenchmark)

protected:
	static void _bind_methods();

public:
	unsigned int iterations = 1000000;

	void benchmark_create_same();
	void benchmark_create_unique();
	void benchmark_copy();

	CPPBenchmarkNodePath();
	~CPPBenchmarkNodePath();
};

} // namespace godot

#endif
