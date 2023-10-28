extends Benchmark

const ITERATIONS = 1_000_000

var number := 0

# Benchmark for loop by:
# 1) Adding a number ITERATIONS times
# 2) Calling a function ITERATIONS times

func benchmark_for_loop_add() -> void:
	for i in ITERATIONS:
		number += 1


func function() -> void:
	pass


func benchmark_for_loop_call() -> void:
	for i in ITERATIONS:
		function()
