#include "lambda_performance.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void CPPBenchmarkLambdaPerformance::_bind_methods() {
	ClassDB::bind_method(D_METHOD("benchmark_lambda_call"), &CPPBenchmarkLambdaPerformance::benchmark_lambda_call);
}

void CPPBenchmarkLambdaPerformance::benchmark_lambda_call() {
	auto lambda = []() {};
	for (int i = 0; i < iterations; i++)
		lambda();
}

CPPBenchmarkLambdaPerformance::CPPBenchmarkLambdaPerformance() {}

CPPBenchmarkLambdaPerformance::~CPPBenchmarkLambdaPerformance() {}
