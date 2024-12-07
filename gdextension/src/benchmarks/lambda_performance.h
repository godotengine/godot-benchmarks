#ifndef CPP_BENCHMARK_LAMBDA_PERFORMANCE_H
#define CPP_BENCHMARK_LAMBDA_PERFORMANCE_H

#include "../cppbenchmark.h"

namespace godot {

class CPPBenchmarkLambdaPerformance : public CPPBenchmark {
	GDCLASS(CPPBenchmarkLambdaPerformance, CPPBenchmark)

protected:
	static void _bind_methods();

public:
	unsigned int iterations = 1000000;
	void benchmark_lambda_call();

	CPPBenchmarkLambdaPerformance();
	~CPPBenchmarkLambdaPerformance();
};

} // namespace godot

#endif
