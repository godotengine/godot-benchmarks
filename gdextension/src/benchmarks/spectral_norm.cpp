#include "spectral_norm.h"

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

#if defined(_WIN32) || defined(_WIN64)
#include <malloc.h>
#endif

using namespace godot;

void CPPBenchmarkSpectralNorm::_bind_methods() {
	ClassDB::bind_method(D_METHOD("benchmark_spectral_norm_100"), &CPPBenchmarkSpectralNorm::benchmark_spectral_norm_100);
	ClassDB::bind_method(D_METHOD("benchmark_spectral_norm_500"), &CPPBenchmarkSpectralNorm::benchmark_spectral_norm_500);
	ClassDB::bind_method(D_METHOD("benchmark_spectral_norm_1000"), &CPPBenchmarkSpectralNorm::benchmark_spectral_norm_1000);
}

double CPPBenchmarkSpectralNorm::eval_a(int i, int j) {
	return 1.0 / ((i + j) * (i + j + 1) / 2 + i + 1);
}

/* multiply vector v by matrix A, each thread evaluate its range only */
void CPPBenchmarkSpectralNorm::multiply_av(double v[], double av[], int n) {
	for (int i = 0; i < n; i++) {
		double sum = 0;
		for (int j = 0; j < n; j++)
			sum += eval_a(i, j) * v[j];

		av[i] = sum;
	}
}

/* multiply vector v by matrix A transposed */
void CPPBenchmarkSpectralNorm::multiply_atv(double v[], double atv[], int n) {
	for (int i = 0; i < n; i++) {
		double sum = 0;
		for (int j = 0; j < n; j++)
			sum += eval_a(j, i) * v[j];

		atv[i] = sum;
	}
}

/* multiply vector v by matrix A and then by matrix A transposed */
void CPPBenchmarkSpectralNorm::multiply_at_av(double v[], double tmp[], double at_av[], int n) {
	multiply_av(v, tmp, n);
	multiply_atv(tmp, at_av, n);
}

void CPPBenchmarkSpectralNorm::calculate_spectral_norm(int n) {
	double *u = (double *)alloca(sizeof(double) * n);
	double *v = (double *)alloca(sizeof(double) * n);
	double *tmp = (double *)alloca(sizeof(double) * n);

	// create unit vector
	for (int i = 0; i < n; i++)
		u[i] = 1.0;

	for (int i = 0; i < 10; i++) {
		multiply_at_av(u, v, tmp, n);
		multiply_at_av(v, u, tmp, n);
	}

	double vbv = 0, vv = 0;
	for (int i = 0; i < n; i++) {
		vbv += u[i] * v[i];
		vv += v[i] * v[i];
	}

	double square_root = Math::sqrt(vbv / vv);
	UtilityFunctions::print(square_root);
}

void CPPBenchmarkSpectralNorm::benchmark_spectral_norm_100() {
	calculate_spectral_norm(100);
}

void CPPBenchmarkSpectralNorm::benchmark_spectral_norm_500() {
	calculate_spectral_norm(500);
}

void CPPBenchmarkSpectralNorm::benchmark_spectral_norm_1000() {
	calculate_spectral_norm(1000);
}

CPPBenchmarkSpectralNorm::CPPBenchmarkSpectralNorm() {}

CPPBenchmarkSpectralNorm::~CPPBenchmarkSpectralNorm() {}
