#ifndef CPP_BENCHMARK_CONTROL_H
#define CPP_BENCHMARK_CONTROL_H

#include "../cppbenchmark.h"

namespace godot {

class CPPBenchmarkControl : public CPPBenchmark {
	GDCLASS(CPPBenchmarkControl, CPPBenchmark)

protected:
	static void _bind_methods();

public:
	void benchmark_control();

	CPPBenchmarkControl();
	~CPPBenchmarkControl();
};

} // namespace godot

#endif
