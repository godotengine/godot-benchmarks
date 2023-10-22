extends Benchmark

const ITERATIONS = 1_000_000

func benchmark_create() -> void:
	for i in ITERATIONS:
		var _s: StringName = "Godot"
