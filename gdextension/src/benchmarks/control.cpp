#include "control.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

// An empty test, to act as a control

void CPPBenchmarkControl::_bind_methods() {
	ClassDB::bind_method(D_METHOD("benchmark_control"), &CPPBenchmarkControl::benchmark_control);
}

void CPPBenchmarkControl::benchmark_control() {}

CPPBenchmarkControl::CPPBenchmarkControl() {}

CPPBenchmarkControl::~CPPBenchmarkControl() {}
