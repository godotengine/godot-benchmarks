#include "forloop.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void CPPBenchmarkForLoop::_bind_methods() {
	ClassDB::bind_method(D_METHOD("benchmark_loop_add"), &CPPBenchmarkForLoop::benchmark_loop_add);
	ClassDB::bind_method(D_METHOD("benchmark_loop_call"), &CPPBenchmarkForLoop::benchmark_loop_call);
}

void CPPBenchmarkForLoop::function() {}

void CPPBenchmarkForLoop::benchmark_loop_add() {
	int number = 0;
	for (int i = 0; i < iterations; i++)
		number++;
}

void CPPBenchmarkForLoop::benchmark_loop_call() {
	for (int i = 0; i < iterations; i++)
		function();
}

CPPBenchmarkForLoop::CPPBenchmarkForLoop() {}

CPPBenchmarkForLoop::~CPPBenchmarkForLoop() {}
