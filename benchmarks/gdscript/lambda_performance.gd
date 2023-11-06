extends Benchmark

const ITERATIONS = 1_000_000

var lambda = func(): pass

# Benchmark lambda function by calling it ITERATION times

func benchmark_lambda_call() -> void:
	for i in ITERATIONS:
		lambda.call()
