extends Benchmark

const ITERATIONS = 10_000_000

var rng := RandomNumberGenerator.new()

func benchmark_global_scope_randi() -> void:
	seed(Manager.RANDOM_SEED)
	for i in ITERATIONS:
		randi()


func benchmark_randi() -> void:
	rng.seed = Manager.RANDOM_SEED
	for i in ITERATIONS:
		rng.randi()


func benchmark_global_scope_randf() -> void:
	seed(Manager.RANDOM_SEED)
	for i in ITERATIONS:
		randf()


func benchmark_randf() -> void:
	rng.seed = Manager.RANDOM_SEED
	for i in ITERATIONS:
		rng.randf()


func benchmark_global_scope_randi_range() -> void:
	seed(Manager.RANDOM_SEED)
	for i in ITERATIONS:
		randi_range(1234, 5678)


func benchmark_randi_range() -> void:
	rng.seed = Manager.RANDOM_SEED
	for i in ITERATIONS:
		rng.randi_range(1234, 5678)


func benchmark_global_scope_randf_range() -> void:
	seed(Manager.RANDOM_SEED)
	for i in ITERATIONS:
		randf_range(1234.0, 5678.0)


func benchmark_randf_range() -> void:
	rng.seed = Manager.RANDOM_SEED
	for i in ITERATIONS:
		rng.randf_range(1234.0, 5678.0)


func benchmark_global_scope_randfn() -> void:
	seed(Manager.RANDOM_SEED)
	for i in ITERATIONS:
		randfn(10.0, 2.0)


func benchmark_randfn() -> void:
	rng.seed = Manager.RANDOM_SEED
	for i in ITERATIONS:
		rng.randfn(10.0, 2.0)


func benchmark_global_scope_randomize() -> void:
	seed(Manager.RANDOM_SEED)
	for i in ITERATIONS:
		randomize()


func benchmark_randomize() -> void:
	rng.seed = Manager.RANDOM_SEED
	for i in ITERATIONS:
		rng.randomize()
