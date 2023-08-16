extends Benchmark

const ITERATIONS = 1_000_000
const LOREM_IPSUM = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."

# Benchmark computation of checksums on a string.

func benchmark_md5_buffer_empty() -> void:
	for i in ITERATIONS:
		"".md5_buffer()


func benchmark_md5_buffer_non_empty() -> void:
	for i in ITERATIONS:
		LOREM_IPSUM.md5_buffer()


func benchmark_sha1_buffer_empty() -> void:
	for i in ITERATIONS:
		"".sha1_buffer()


func benchmark_sha1_buffer_non_empty() -> void:
	for i in ITERATIONS:
		LOREM_IPSUM.sha1_buffer()


func benchmark_sha256_buffer_empty() -> void:
	for i in ITERATIONS:
		"".sha256_buffer()


func benchmark_sha256_buffer_non_empty() -> void:
	for i in ITERATIONS:
		LOREM_IPSUM.sha256_buffer()


func benchmark_md5_text_empty() -> void:
	for i in ITERATIONS:
		"".md5_text()


func benchmark_md5_text_non_empty() -> void:
	for i in ITERATIONS:
		LOREM_IPSUM.md5_text()


func benchmark_sha1_text_empty() -> void:
	for i in ITERATIONS:
		"".sha1_text()


func benchmark_sha1_text_non_empty() -> void:
	for i in ITERATIONS:
		LOREM_IPSUM.sha1_text()


func benchmark_sha256_text_empty() -> void:
	for i in ITERATIONS:
		"".sha256_text()


func benchmark_sha256_text_non_empty() -> void:
	for i in ITERATIONS:
		LOREM_IPSUM.sha256_text()
