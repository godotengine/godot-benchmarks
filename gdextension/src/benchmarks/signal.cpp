#include "signal.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void CPPBenchmarkSignal::_bind_methods() {
	ClassDB::bind_method(D_METHOD("benchmark_emission_params_0"), &CPPBenchmarkSignal::benchmark_emission_params_0);
	ClassDB::bind_method(D_METHOD("benchmark_emission_params_1"), &CPPBenchmarkSignal::benchmark_emission_params_1);
	ClassDB::bind_method(D_METHOD("benchmark_emission_params_10"), &CPPBenchmarkSignal::benchmark_emission_params_10);

	ClassDB::bind_method(D_METHOD("on_emit"), &CPPBenchmarkSignal::on_emit);
	ClassDB::bind_method(D_METHOD("on_emit_params_1", "arg1"), &CPPBenchmarkSignal::on_emit_params_1);
	ClassDB::bind_method(D_METHOD("on_emit_params_10", "arg1", "arg2", "arg3", "arg4", "arg5", "arg6", "arg7", "arg8", "arg9", "arg10"), &CPPBenchmarkSignal::on_emit_params_10);

	ADD_SIGNAL(MethodInfo("emitter"));
	ADD_SIGNAL(MethodInfo("emitter_params_1", PropertyInfo(Variant::INT, "arg1")));
	ADD_SIGNAL(MethodInfo("emitter_params_10",
			PropertyInfo(Variant::INT, "arg1"),
			PropertyInfo(Variant::INT, "arg2"),
			PropertyInfo(Variant::INT, "arg3"),
			PropertyInfo(Variant::INT, "arg4"),
			PropertyInfo(Variant::INT, "arg5"),
			PropertyInfo(Variant::INT, "arg6"),
			PropertyInfo(Variant::INT, "arg7"),
			PropertyInfo(Variant::INT, "arg8"),
			PropertyInfo(Variant::INT, "arg9"),
			PropertyInfo(Variant::INT, "arg10")));
}

void CPPBenchmarkSignal::on_emit() {}

void CPPBenchmarkSignal::on_emit_params_1(int arg1) {}

void CPPBenchmarkSignal::on_emit_params_10(int arg1, int arg2, int arg3, int arg4, int arg5,
		int arg6, int arg7, int arg8, int arg9, int arg10) {}

void CPPBenchmarkSignal::benchmark_emission_params_0() {
	connect("emitter", callable_mp(this, &CPPBenchmarkSignal::on_emit));
	for (unsigned int i = 0; i < iterations; ++i) {
		emit_signal("emitter");
	}
	disconnect("emitter", callable_mp(this, &CPPBenchmarkSignal::on_emit));
}

void CPPBenchmarkSignal::benchmark_emission_params_1() {
	connect("emitter_params_1", callable_mp(this, &CPPBenchmarkSignal::on_emit_params_1));
	for (unsigned int i = 0; i < iterations; ++i) {
		emit_signal("emitter_params_1", i);
	}
	disconnect("emitter_params_1", callable_mp(this, &CPPBenchmarkSignal::on_emit_params_1));
}

void CPPBenchmarkSignal::benchmark_emission_params_10() {
	connect("emitter_params_10", callable_mp(this, &CPPBenchmarkSignal::on_emit_params_10));
	for (unsigned int i = 0; i < iterations; ++i) {
		emit_signal("emitter_params_10", i, i, i, i, i, i, i, i, i, i);
	}
	disconnect("emitter_params_10", callable_mp(this, &CPPBenchmarkSignal::on_emit_params_10));
}

CPPBenchmarkSignal::CPPBenchmarkSignal() {}

CPPBenchmarkSignal::~CPPBenchmarkSignal() {}
