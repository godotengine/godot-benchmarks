#include "cppbenchmark.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void CPPBenchmark::_bind_methods() {
	ClassDB::bind_method(D_METHOD("get_benchmark_time"), &CPPBenchmark::get_benchmark_time);
	ClassDB::bind_method(D_METHOD("set_benchmark_time", "p_benchmark_time"), &CPPBenchmark::set_benchmark_time);
	ClassDB::add_property("CPPBenchmark", PropertyInfo(Variant::INT, "benchmark_time"), "set_benchmark_time", "get_benchmark_time");

	ClassDB::bind_method(D_METHOD("get_test_render_cpu"), &CPPBenchmark::get_test_render_cpu);
	ClassDB::bind_method(D_METHOD("set_test_render_cpu", "p_test_render_cpu"), &CPPBenchmark::set_test_render_cpu);
	ClassDB::add_property("CPPBenchmark", PropertyInfo(Variant::BOOL, "test_render_cpu"), "set_test_render_cpu", "get_test_render_cpu");

	ClassDB::bind_method(D_METHOD("get_test_render_gpu"), &CPPBenchmark::get_test_render_gpu);
	ClassDB::bind_method(D_METHOD("set_test_render_gpu", "p_test_render_gpu"), &CPPBenchmark::set_test_render_gpu);
	ClassDB::add_property("CPPBenchmark", PropertyInfo(Variant::BOOL, "test_render_gpu"), "set_test_render_gpu", "get_test_render_gpu");

	ClassDB::bind_method(D_METHOD("get_test_idle"), &CPPBenchmark::get_test_idle);
	ClassDB::bind_method(D_METHOD("set_test_idle", "p_test_idle"), &CPPBenchmark::set_test_idle);
	ClassDB::add_property("CPPBenchmark", PropertyInfo(Variant::BOOL, "test_idle"), "set_test_idle", "get_test_idle");

	ClassDB::bind_method(D_METHOD("get_test_physics"), &CPPBenchmark::get_test_physics);
	ClassDB::bind_method(D_METHOD("set_test_physics", "p_test_physics"), &CPPBenchmark::set_test_physics);
	ClassDB::add_property("CPPBenchmark", PropertyInfo(Variant::BOOL, "test_physics"), "set_test_physics", "get_test_physics");
}

CPPBenchmark::CPPBenchmark() {
	// Initialize any variables here.
}

CPPBenchmark::~CPPBenchmark() {
	// Add your cleanup here.
}

void CPPBenchmark::set_benchmark_time(const int p_benchmark_time) {
	benchmark_time = p_benchmark_time;
}

int CPPBenchmark::get_benchmark_time() const {
	return test_render_cpu;
}

void CPPBenchmark::set_test_render_cpu(const bool p_test_render_cpu) {
	test_render_cpu = p_test_render_cpu;
}

bool CPPBenchmark::get_test_render_cpu() const {
	return test_render_cpu;
}

void CPPBenchmark::set_test_render_gpu(const bool p_test_render_gpu) {
	test_render_gpu = p_test_render_gpu;
}

bool CPPBenchmark::get_test_render_gpu() const {
	return test_render_gpu;
}

void CPPBenchmark::set_test_idle(const bool p_test_idle) {
	test_idle = p_test_idle;
}

bool CPPBenchmark::get_test_idle() const {
	return test_idle;
}

void CPPBenchmark::set_test_physics(const bool p_test_physics) {
	test_physics = p_test_physics;
}

bool CPPBenchmark::get_test_physics() const {
	return test_physics;
}
