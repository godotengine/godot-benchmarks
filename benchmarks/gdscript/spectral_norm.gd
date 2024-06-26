extends Benchmark

# Ported from
# https://github.com/hanabi1224/Programming-Language-Benchmarks/blob/main/bench/algorithm/spectral-norm/1.lua


func eval_a(i: int, j: int) -> float:
	var ij := i + j - 1
	return 1.0 / (ij * (ij - 1) * 0.5 + i)


func av(x: PackedFloat64Array, y: PackedFloat64Array, n: int) -> void:
	for i in n:
		var a := 0.0
		for j in n:
			a = a + x[j] * eval_a(i, j)
		y[i] = a


func atv(x: PackedFloat64Array, y: PackedFloat64Array, n: int) -> void:
	for i in n:
		var a := 0.0
		for j in n:
			a = a + x[j] * eval_a(j, i)
		y[i] = a


func at_av(x: PackedFloat64Array, y: PackedFloat64Array, t: PackedFloat64Array, n: int) -> void:
	av(x, t, n)
	atv(t, y, n)


func calculate_spectral_norm(n: int) -> void:
	var u := PackedFloat64Array([])
	u.resize(n)
	var v := PackedFloat64Array([])
	v.resize(n)
	var t := PackedFloat64Array([])
	t.resize(n)
	for i in n:
		u[i] = 1.0
	for i in 10:
		at_av(u, v, t, n)
		at_av(v, u, t, n)
	var vbv := 0.0
	var vv := 0.0
	for i in n:
		var ui := u[i]
		var vi := v[i]
		vbv += ui * vi
		vv += vi * vi
	print("%.9f" % sqrt(vbv / vv))


func benchmark_spectral_norm_100() -> void:
	calculate_spectral_norm(100)


func benchmark_spectral_norm_500() -> void:
	calculate_spectral_norm(500)


func benchmark_spectral_norm_1000() -> void:
	calculate_spectral_norm(1000)
