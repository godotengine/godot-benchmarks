#ifndef CPP_BENCHMARK_SPECTRAL_NORM_H
#define CPP_BENCHMARK_SPECTRAL_NORM_H

#include "../cppbenchmark.h"

namespace godot {
    class CPPBenchmarkSpectralNorm : public CPPBenchmark {
        GDCLASS(CPPBenchmarkSpectralNorm, CPPBenchmark)

        private:
            double eval_a(int i, int j);
            void multiply_av(double v[], double av[], int n);
            void multiply_atv(double v[], double atv[], int n);
            void multiply_at_av(double v[], double tmp[], double at_av[], int n);
            void calculate_spectral_norm(int input);
        protected:
	        static void _bind_methods();
        public:
            void benchmark_spectral_norm_100();
            void benchmark_spectral_norm_500();
            void benchmark_spectral_norm_1000();
            CPPBenchmarkSpectralNorm();
            ~CPPBenchmarkSpectralNorm();
    };
}
#endif
