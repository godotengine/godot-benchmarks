#ifndef CPP_BENCHMARK_RANDOM_NUMBER_GENERATOR_H
#define CPP_BENCHMARK_RANDOM_NUMBER_GENERATOR_H

#include "../cppbenchmark.h"
#include <godot_cpp/classes/random_number_generator.hpp>

namespace godot {

class CPPBenchmarkRandomNumberGenerator : public CPPBenchmark {
	GDCLASS(CPPBenchmarkRandomNumberGenerator, CPPBenchmark)

protected:
	static void _bind_methods();

private:
	Ref<RandomNumberGenerator> rng;

public:
	unsigned int iterations = 10000000;

	void benchmark_randi();
	void benchmark_randf();
	void benchmark_randi_range();
	void benchmark_randf_range();
	void benchmark_randfn();
	void benchmark_randomize();

	CPPBenchmarkRandomNumberGenerator();
	~CPPBenchmarkRandomNumberGenerator();
};

} // namespace godot

#endif
