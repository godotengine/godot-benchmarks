#include "string_name.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void CPPBenchmarkStringName::_bind_methods() {
	ClassDB::bind_method(D_METHOD("benchmark_create_same"), &CPPBenchmarkStringName::benchmark_create_same);
	ClassDB::bind_method(D_METHOD("benchmark_create_unique"), &CPPBenchmarkStringName::benchmark_create_unique);
	ClassDB::bind_method(D_METHOD("benchmark_copy"), &CPPBenchmarkStringName::benchmark_copy);
	ClassDB::bind_method(D_METHOD("benchmark_compare"), &CPPBenchmarkStringName::benchmark_compare);
}

void CPPBenchmarkStringName::benchmark_create_same() {
	for (unsigned int i = 0; i < iterations; ++i) {
		StringName sn("Godot");
		// sn is destroyed here, decrementing the refcount.
	}
}

void CPPBenchmarkStringName::benchmark_create_unique() {
	for (unsigned int i = 0; i < iterations; ++i) {
		StringName sn(String("Godot") + String::num_int64(i));
		// sn is destroyed here, removing it from the hash table.
	}
}

void CPPBenchmarkStringName::benchmark_copy() {
	StringName original("Godot");
	for (unsigned int i = 0; i < iterations; ++i) {
		StringName copy(original);
	}
}

void CPPBenchmarkStringName::benchmark_compare() {
	StringName a("Godot");
	StringName b("Godot");
	bool result = false;
	for (unsigned int i = 0; i < iterations; ++i) {
		result = (a == b);
	}
}

CPPBenchmarkStringName::CPPBenchmarkStringName() {}

CPPBenchmarkStringName::~CPPBenchmarkStringName() {}
