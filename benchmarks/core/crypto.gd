extends Benchmark

const BYTES_SMALL = 100_000_000
const BYTES = 1_000_000_000

var crypto := Crypto.new()

func benchmark_generate_1m_random_bytes_10_at_a_time() -> void:
	@warning_ignore("integer_division")
	var iterations = BYTES_SMALL / 10
	for i in iterations:
		crypto.generate_random_bytes(10)


func benchmark_generate_1g_random_bytes_1k_at_a_time() -> void:
	@warning_ignore("integer_division")
	var iterations = BYTES / 1000
	for i in iterations:
		crypto.generate_random_bytes(1000)


func benchmark_generate_rsa_2048() -> void:
	crypto.generate_rsa(2048)


func benchmark_generate_rsa_4096() -> void:
	crypto.generate_rsa(4096)
