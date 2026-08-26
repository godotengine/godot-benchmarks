#ifndef CPP_BENCHMARK_SIGNAL_H
#define CPP_BENCHMARK_SIGNAL_H

#include "../cppbenchmark.h"

namespace godot {

class CPPBenchmarkSignal : public CPPBenchmark {
	GDCLASS(CPPBenchmarkSignal, CPPBenchmark)

protected:
	static void _bind_methods();

private:
	void on_emit();
	void on_emit_params_1(int arg1);
	void on_emit_params_10(int arg1, int arg2, int arg3, int arg4, int arg5,
			int arg6, int arg7, int arg8, int arg9, int arg10);

public:
	unsigned int iterations = 1000000;

	void benchmark_emission_params_0();
	void benchmark_emission_params_1();
	void benchmark_emission_params_10();

	CPPBenchmarkSignal();
	~CPPBenchmarkSignal();
};

} // namespace godot

#endif
