#ifndef CPP_BENCHMARK_STRING_MANIPULATION_H
#define CPP_BENCHMARK_STRING_MANIPULATION_H

#include "../cppbenchmark.h"

namespace godot {

class CPPBenchmarkStringManipulation : public CPPBenchmark {
	GDCLASS(CPPBenchmarkStringManipulation, CPPBenchmark)

protected:
	static void _bind_methods();

public:
	unsigned int iterations = 1000000;

	void benchmark_begins_with();
	void benchmark_ends_with();
	void benchmark_count();
	void benchmark_countn();
	void benchmark_contains();
	void benchmark_find();
	void benchmark_findn();
	void benchmark_rfind();
	void benchmark_rfindn();
	void benchmark_substr();
	void benchmark_insert();
	void benchmark_get_slice();
	void benchmark_get_slice_count();
	void benchmark_bigrams();
	void benchmark_split();
	void benchmark_rsplit();
	void benchmark_split_floats();
	void benchmark_pad_zeros_pre_constructed();
	void benchmark_pad_zeros();
	void benchmark_pad_decimals_pre_constructed();
	void benchmark_pad_decimals();
	void benchmark_lpad();
	void benchmark_rpad();
	void benchmark_similarity();
	void benchmark_simplify_path();
	void benchmark_capitalize();
	void benchmark_to_snake_case();
	void benchmark_to_camel_case();
	void benchmark_to_pascal_case();
	void benchmark_to_lower();
	void benchmark_uri_decode();
	void benchmark_uri_encode();
	void benchmark_xml_escape();
	void benchmark_xml_unescape();
	void benchmark_humanize_size();
	void benchmark_is_valid_filename();
	void benchmark_validate_filename();
	void benchmark_validate_node_name();
	void benchmark_casecmp_to();
	void benchmark_nocasecmp_to();
	void benchmark_naturalnocasecmp_to();
	void benchmark_to_utf8_buffer();
	void benchmark_to_utf16_buffer();
	void benchmark_to_utf32_buffer();
	void benchmark_to_wchar_buffer();

	CPPBenchmarkStringManipulation();
	~CPPBenchmarkStringManipulation();
};

} // namespace godot

#endif
