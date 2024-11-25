extends Benchmark

@warning_ignore("unused_signal")
signal emitter

const ITERATIONS = 2_000_000

func function_callable() -> void:
	pass


func benchmark_function_callable() -> void:
	for i in ITERATIONS:
		function_callable.call()


func benchmark_lambda_inline_callable() -> void:
	for i in ITERATIONS:
		(func lambda_callable() -> void: pass).call()


func benchmark_lambda_variable_callable() -> void:
	var variable_callable := \
			func lambda_callable() -> void:
				pass

	for i in ITERATIONS:
		variable_callable.call()
