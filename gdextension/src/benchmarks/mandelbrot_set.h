#ifndef CPP_BENCHMARK_MANDELBROT_SET_H
#define CPP_BENCHMARK_MANDELBROT_SET_H

#include "../cppbenchmark.h"

namespace godot {

class CPPBenchmarkMandelbrotSet : public CPPBenchmark {
	GDCLASS(CPPBenchmarkMandelbrotSet, CPPBenchmark)

	int width = 600;
	int height = 400;
	int max_iteration = 1000;
	Color hsv(float hue, float sat, float value);
	void mandelbrot_set(int p_width, int p_height, int p_max_iteration);

protected:
	static void _bind_methods();

public:
	void benchmark_mandelbrot_set();

	CPPBenchmarkMandelbrotSet();
	~CPPBenchmarkMandelbrotSet();
};

} // namespace godot

#endif
