extends Benchmark

const NUM_ITERATIONS := 1000000

func _bench_noise(noise) -> void:
	for i in NUM_ITERATIONS:
		noise.get_noise_1d(i)
		noise.get_noise_2d(i, i)
		noise.get_noise_3d(i, i, i)

func _fast_noise(type: FastNoiseLite.NoiseType) -> FastNoiseLite:
	var noise := FastNoiseLite.new()
	noise.noise_type = type
	noise.seed = 234
	return noise

func benchmark_value() -> void:
	return _bench_noise(_fast_noise(FastNoiseLite.TYPE_VALUE))

func benchmark_value_cubic() -> void:
	return _bench_noise(_fast_noise(FastNoiseLite.TYPE_VALUE_CUBIC))

func benchmark_perlin() -> void:
	return _bench_noise(_fast_noise(FastNoiseLite.TYPE_PERLIN))

func benchmark_cellular() -> void:
	return _bench_noise(_fast_noise(FastNoiseLite.TYPE_CELLULAR))

func benchmark_simplex() -> void:
	return _bench_noise(_fast_noise(FastNoiseLite.TYPE_SIMPLEX))

func benchmark_simplex_smooth() -> void:
	return _bench_noise(_fast_noise(FastNoiseLite.TYPE_SIMPLEX_SMOOTH))
