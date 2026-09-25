#include "array_ops.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void CPPBenchmarkArrayOps::_bind_methods() {
	ClassDB::bind_method(D_METHOD("benchmark_reverse"), &CPPBenchmarkArrayOps::benchmark_reverse);
	ClassDB::bind_method(D_METHOD("benchmark_bsearch"), &CPPBenchmarkArrayOps::benchmark_bsearch);
	ClassDB::bind_method(D_METHOD("benchmark_append_array"), &CPPBenchmarkArrayOps::benchmark_append_array);
	ClassDB::bind_method(D_METHOD("benchmark_fill"), &CPPBenchmarkArrayOps::benchmark_fill);
}

void CPPBenchmarkArrayOps::benchmark_reverse() {
	for (unsigned int i = 0; i < iterations; ++i) {
		array_10.reverse();
	}
}

void CPPBenchmarkArrayOps::benchmark_bsearch() {
	for (unsigned int i = 0; i < iterations; ++i) {
		int64_t index = array_10.bsearch(array_10[i % array_10.size()], true);
		ERR_FAIL_COND(index == -1);
	}
}

void CPPBenchmarkArrayOps::benchmark_append_array() {
	for (unsigned int i = 0; i < iterations; ++i) {
		array_100.resize(100);
		array_100.append_array(array_10);
	}
}

void CPPBenchmarkArrayOps::benchmark_fill() {
	for (unsigned int i = 0; i < iterations; ++i) {
		array_10.fill(100 + i);
	}
}

CPPBenchmarkArrayOps::CPPBenchmarkArrayOps() {
	array_10.resize(10);
	for (int64_t i = 0; i < 10; ++i) {
		array_10[i] = i;
	}

	array_100.resize(100);
	for (int64_t i = 0; i < 100; ++i) {
		array_100[i] = i;
	}
}

CPPBenchmarkArrayOps::~CPPBenchmarkArrayOps() {}
