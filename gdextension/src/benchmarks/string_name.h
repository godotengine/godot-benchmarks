#ifndef CPP_BENCHMARK_STRING_NAME_H
#define CPP_BENCHMARK_STRING_NAME_H

#include "../cppbenchmark.h"

namespace godot {

class CPPBenchmarkStringName : public CPPBenchmark {
	GDCLASS(CPPBenchmarkStringName, CPPBenchmark)

protected:
	static void _bind_methods();

public:
	unsigned int iterations = 1000000;

	void benchmark_create_same();
	void benchmark_create_unique();
	void benchmark_copy();
	void benchmark_compare();

	CPPBenchmarkStringName();
	~CPPBenchmarkStringName();
};

} // namespace godot

#endif
