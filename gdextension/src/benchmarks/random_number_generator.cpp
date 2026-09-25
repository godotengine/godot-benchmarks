#include "random_number_generator.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

const uint64_t RANDOM_SEED = 0x60d07;

void CPPBenchmarkRandomNumberGenerator::_bind_methods() {
	ClassDB::bind_method(D_METHOD("benchmark_randi"), &CPPBenchmarkRandomNumberGenerator::benchmark_randi);
	ClassDB::bind_method(D_METHOD("benchmark_randf"), &CPPBenchmarkRandomNumberGenerator::benchmark_randf);
	ClassDB::bind_method(D_METHOD("benchmark_randi_range"), &CPPBenchmarkRandomNumberGenerator::benchmark_randi_range);
	ClassDB::bind_method(D_METHOD("benchmark_randf_range"), &CPPBenchmarkRandomNumberGenerator::benchmark_randf_range);
	ClassDB::bind_method(D_METHOD("benchmark_randfn"), &CPPBenchmarkRandomNumberGenerator::benchmark_randfn);
	ClassDB::bind_method(D_METHOD("benchmark_randomize"), &CPPBenchmarkRandomNumberGenerator::benchmark_randomize);
}

void CPPBenchmarkRandomNumberGenerator::benchmark_randi() {
	rng->set_seed(RANDOM_SEED);
	for (unsigned int i = 0; i < iterations; ++i) {
		rng->randi();
	}
}

void CPPBenchmarkRandomNumberGenerator::benchmark_randf() {
	rng->set_seed(RANDOM_SEED);
	for (unsigned int i = 0; i < iterations; ++i) {
		rng->randf();
	}
}

void CPPBenchmarkRandomNumberGenerator::benchmark_randi_range() {
	rng->set_seed(RANDOM_SEED);
	for (unsigned int i = 0; i < iterations; ++i) {
		rng->randi_range(1234, 5678);
	}
}

void CPPBenchmarkRandomNumberGenerator::benchmark_randf_range() {
	rng->set_seed(RANDOM_SEED);
	for (unsigned int i = 0; i < iterations; ++i) {
		rng->randf_range(1234.0, 5678.0);
	}
}

void CPPBenchmarkRandomNumberGenerator::benchmark_randfn() {
	rng->set_seed(RANDOM_SEED);
	for (unsigned int i = 0; i < iterations; ++i) {
		rng->randfn(10.0, 2.0);
	}
}

void CPPBenchmarkRandomNumberGenerator::benchmark_randomize() {
	for (unsigned int i = 0; i < iterations; ++i) {
		rng->randomize();
	}
}

CPPBenchmarkRandomNumberGenerator::CPPBenchmarkRandomNumberGenerator() {
	rng.instantiate();
}

CPPBenchmarkRandomNumberGenerator::~CPPBenchmarkRandomNumberGenerator() {}
