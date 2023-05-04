extends Benchmark

const ITERATIONS = 100_000

var crypto := Crypto.new()


func benchmark_generate_10_random_bytes() -> void:
	for i in ITERATIONS:
		crypto.generate_random_bytes(10)


func benchmark_generate_1k_random_bytes() -> void:
	for i in ITERATIONS:
		crypto.generate_random_bytes(1000)


func benchmark_generate_1m_random_bytes() -> void:
	for i in ITERATIONS:
		crypto.generate_random_bytes(1_000_000)


func benchmark_generate_1g_random_bytes() -> void:
	for i in ITERATIONS:
		crypto.generate_random_bytes(1_000_000_000)


func benchmark_generate_rsa_2048() -> void:
	crypto.generate_rsa(2048)


func benchmark_generate_rsa_4096() -> void:
	crypto.generate_rsa(4096)
