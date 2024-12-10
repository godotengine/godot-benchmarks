#include "string_checksum.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void CPPBenchmarkStringChecksum::_bind_methods() {
	ClassDB::bind_method(D_METHOD("benchmark_md5_buffer_empty"), &CPPBenchmarkStringChecksum::benchmark_md5_buffer_empty);
	ClassDB::bind_method(D_METHOD("benchmark_md5_buffer_non_empty"), &CPPBenchmarkStringChecksum::benchmark_md5_buffer_non_empty);
	ClassDB::bind_method(D_METHOD("benchmark_sha1_buffer_empty"), &CPPBenchmarkStringChecksum::benchmark_sha1_buffer_empty);
	ClassDB::bind_method(D_METHOD("benchmark_sha1_buffer_non_empty"), &CPPBenchmarkStringChecksum::benchmark_sha1_buffer_non_empty);
	ClassDB::bind_method(D_METHOD("benchmark_sha256_buffer_empty"), &CPPBenchmarkStringChecksum::benchmark_sha256_buffer_empty);
	ClassDB::bind_method(D_METHOD("benchmark_sha256_buffer_non_empty"), &CPPBenchmarkStringChecksum::benchmark_sha256_buffer_non_empty);
	ClassDB::bind_method(D_METHOD("benchmark_md5_text_empty"), &CPPBenchmarkStringChecksum::benchmark_md5_text_empty);
	ClassDB::bind_method(D_METHOD("benchmark_md5_text_non_empty"), &CPPBenchmarkStringChecksum::benchmark_md5_text_non_empty);
	ClassDB::bind_method(D_METHOD("benchmark_sha1_text_empty"), &CPPBenchmarkStringChecksum::benchmark_sha1_text_empty);
	ClassDB::bind_method(D_METHOD("benchmark_sha1_text_non_empty"), &CPPBenchmarkStringChecksum::benchmark_sha1_text_non_empty);
	ClassDB::bind_method(D_METHOD("benchmark_sha256_text_empty"), &CPPBenchmarkStringChecksum::benchmark_sha256_text_empty);
	ClassDB::bind_method(D_METHOD("benchmark_sha256_text_non_empty"), &CPPBenchmarkStringChecksum::benchmark_sha256_text_non_empty);
}

void CPPBenchmarkStringChecksum::benchmark_md5_buffer_empty() {
	for (int i = 0; i < iterations; i++)
		String("").md5_buffer();
}

void CPPBenchmarkStringChecksum::benchmark_md5_buffer_non_empty() {
	for (int i = 0; i < iterations; i++)
		LOREM_IPSUM.md5_buffer();
}

void CPPBenchmarkStringChecksum::benchmark_sha1_buffer_empty() {
	for (int i = 0; i < iterations; i++)
		String("").sha1_buffer();
}

void CPPBenchmarkStringChecksum::benchmark_sha1_buffer_non_empty() {
	for (int i = 0; i < iterations; i++)
		LOREM_IPSUM.sha1_buffer();
}

void CPPBenchmarkStringChecksum::benchmark_sha256_buffer_empty() {
	for (int i = 0; i < iterations; i++)
		String("").sha256_buffer();
}

void CPPBenchmarkStringChecksum::benchmark_sha256_buffer_non_empty() {
	for (int i = 0; i < iterations; i++)
		LOREM_IPSUM.sha256_buffer();
}

void CPPBenchmarkStringChecksum::benchmark_md5_text_empty() {
	for (int i = 0; i < iterations; i++)
		String("").md5_text();
}

void CPPBenchmarkStringChecksum::benchmark_md5_text_non_empty() {
	for (int i = 0; i < iterations; i++)
		LOREM_IPSUM.md5_text();
}

void CPPBenchmarkStringChecksum::benchmark_sha1_text_empty() {
	for (int i = 0; i < iterations; i++)
		String("").sha1_text();
}

void CPPBenchmarkStringChecksum::benchmark_sha1_text_non_empty() {
	for (int i = 0; i < iterations; i++)
		LOREM_IPSUM.sha1_text();
}

void CPPBenchmarkStringChecksum::benchmark_sha256_text_empty() {
	for (int i = 0; i < iterations; i++)
		String("").sha256_text();
}

void CPPBenchmarkStringChecksum::benchmark_sha256_text_non_empty() {
	for (int i = 0; i < iterations; i++)
		LOREM_IPSUM.sha256_text();
}

CPPBenchmarkStringChecksum::CPPBenchmarkStringChecksum() {}

CPPBenchmarkStringChecksum::~CPPBenchmarkStringChecksum() {}
