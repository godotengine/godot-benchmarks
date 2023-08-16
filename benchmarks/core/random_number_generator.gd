extends Benchmark

const ITERATIONS = 10_000_000
const RANDOM_SEED = preload("res://main.gd").RANDOM_SEED

var rng := RandomNumberGenerator.new()

func benchmark_global_scope_randi() -> void:
	# Reset the random seed to improve reproducibility of this benchmark.
	seed(RANDOM_SEED)
	for i in ITERATIONS:
		randi()

	# Reset the random seed again to improve reproducibility of other benchmarks.
	seed(RANDOM_SEED)


func benchmark_randi() -> void:
	rng.seed = RANDOM_SEED
	for i in ITERATIONS:
		rng.randi()
	rng.seed = RANDOM_SEED


func benchmark_global_scope_randf() -> void:
	seed(RANDOM_SEED)
	for i in ITERATIONS:
		randf()
	seed(RANDOM_SEED)


func benchmark_randf() -> void:
	rng.seed = RANDOM_SEED
	for i in ITERATIONS:
		rng.randf()
	rng.seed = RANDOM_SEED


func benchmark_global_scope_randi_range() -> void:
	seed(RANDOM_SEED)
	for i in ITERATIONS:
		randi_range(1234, 5678)
	seed(RANDOM_SEED)


func benchmark_randi_range() -> void:
	rng.seed = RANDOM_SEED
	for i in ITERATIONS:
		rng.randi_range(1234, 5678)
	rng.seed = RANDOM_SEED


func benchmark_global_scope_randf_range() -> void:
	seed(RANDOM_SEED)
	for i in ITERATIONS:
		randf_range(1234.0, 5678.0)
	seed(RANDOM_SEED)


func benchmark_randf_range() -> void:
	rng.seed = RANDOM_SEED
	for i in ITERATIONS:
		rng.randf_range(1234.0, 5678.0)
	rng.seed = RANDOM_SEED


func benchmark_global_scope_randfn() -> void:
	seed(RANDOM_SEED)
	for i in ITERATIONS:
		randfn(10.0, 2.0)
	seed(RANDOM_SEED)


func benchmark_randfn() -> void:
	rng.seed = RANDOM_SEED
	for i in ITERATIONS:
		rng.randfn(10.0, 2.0)
	rng.seed = RANDOM_SEED


func benchmark_global_scope_randomize() -> void:
	seed(RANDOM_SEED)
	for i in ITERATIONS:
		randomize()
	seed(RANDOM_SEED)


func benchmark_randomize() -> void:
	rng.seed = RANDOM_SEED
	for i in ITERATIONS:
		rng.randomize()
	rng.seed = RANDOM_SEED
