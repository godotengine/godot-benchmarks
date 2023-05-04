extends Benchmark

signal emitter
signal emitter_params_1(arg1)
signal emitter_params_10(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)

const ITERATIONS = 1_000_000

func on_emit() -> void:
	pass


func on_emit_params_1(_arg1) -> void:
	pass


func on_emit_params_10(_arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9, _arg10) -> void:
	pass


func benchmark_emission_params_0() -> void:
	emitter.connect(on_emit)
	for i in ITERATIONS:
		emitter.emit()
	emitter.disconnect(on_emit)


func benchmark_emission_params_1() -> void:
	emitter_params_1.connect(on_emit_params_1)
	for i in ITERATIONS:
		emitter_params_1.emit(i)
	emitter_params_1.disconnect(on_emit_params_1)


func benchmark_emission_params_10() -> void:
	emitter_params_10.connect(on_emit_params_10)
	for i in ITERATIONS:
		emitter_params_10.emit(i, i, i, i, i, i, i, i, i, i)
	emitter_params_10.disconnect(on_emit_params_10)
