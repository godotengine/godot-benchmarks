#include "node_path.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void CPPBenchmarkNodePath::_bind_methods() {
	ClassDB::bind_method(D_METHOD("benchmark_create_same"), &CPPBenchmarkNodePath::benchmark_create_same);
	ClassDB::bind_method(D_METHOD("benchmark_create_unique"), &CPPBenchmarkNodePath::benchmark_create_unique);
	ClassDB::bind_method(D_METHOD("benchmark_copy"), &CPPBenchmarkNodePath::benchmark_copy);
}

void CPPBenchmarkNodePath::benchmark_create_same() {
	for (unsigned int i = 0; i < iterations; ++i) {
		NodePath np("Node/Child/GrandChild");
		// np is destroyed here, decrementing the refcount.
	}
}

void CPPBenchmarkNodePath::benchmark_create_unique() {
	for (unsigned int i = 0; i < iterations; ++i) {
		NodePath np(String("Node/Child/") + String::num_int64(i));
		// np is destroyed here, removing its components from the hash table.
	}
}

void CPPBenchmarkNodePath::benchmark_copy() {
	NodePath original("Node/Child/GrandChild");
	for (unsigned int i = 0; i < iterations; ++i) {
		NodePath copy(original);
	}
}

CPPBenchmarkNodePath::CPPBenchmarkNodePath() {}

CPPBenchmarkNodePath::~CPPBenchmarkNodePath() {}
