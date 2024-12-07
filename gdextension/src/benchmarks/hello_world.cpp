#include "hello_world.h"

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void CPPBenchmarkHelloWorld::_bind_methods() {
	ClassDB::bind_method(D_METHOD("benchmark_hello_world"), &CPPBenchmarkHelloWorld::benchmark_hello_world);
}

void CPPBenchmarkHelloWorld::benchmark_hello_world() {
	UtilityFunctions::print("Hello world!");
}

CPPBenchmarkHelloWorld::CPPBenchmarkHelloWorld() {}

CPPBenchmarkHelloWorld::~CPPBenchmarkHelloWorld() {}
