#include "string_manipulation.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void CPPBenchmarkStringManipulation::_bind_methods() {
    ClassDB::bind_method(D_METHOD("benchmark_begins_with"), &CPPBenchmarkStringManipulation::benchmark_begins_with);
    ClassDB::bind_method(D_METHOD("benchmark_ends_with"), &CPPBenchmarkStringManipulation::benchmark_ends_with);
    ClassDB::bind_method(D_METHOD("benchmark_count"), &CPPBenchmarkStringManipulation::benchmark_count);
    ClassDB::bind_method(D_METHOD("benchmark_countn"), &CPPBenchmarkStringManipulation::benchmark_countn);
    ClassDB::bind_method(D_METHOD("benchmark_contains"), &CPPBenchmarkStringManipulation::benchmark_contains);
    ClassDB::bind_method(D_METHOD("benchmark_find"), &CPPBenchmarkStringManipulation::benchmark_find);
    ClassDB::bind_method(D_METHOD("benchmark_findn"), &CPPBenchmarkStringManipulation::benchmark_findn);
    ClassDB::bind_method(D_METHOD("benchmark_rfind"), &CPPBenchmarkStringManipulation::benchmark_rfind);
    ClassDB::bind_method(D_METHOD("benchmark_rfindn"), &CPPBenchmarkStringManipulation::benchmark_rfindn);
    ClassDB::bind_method(D_METHOD("benchmark_substr"), &CPPBenchmarkStringManipulation::benchmark_substr);
    ClassDB::bind_method(D_METHOD("benchmark_insert"), &CPPBenchmarkStringManipulation::benchmark_insert);
    ClassDB::bind_method(D_METHOD("benchmark_get_slice"), &CPPBenchmarkStringManipulation::benchmark_get_slice);
    ClassDB::bind_method(D_METHOD("benchmark_get_slice_count"), &CPPBenchmarkStringManipulation::benchmark_get_slice_count);
    ClassDB::bind_method(D_METHOD("benchmark_bigrams"), &CPPBenchmarkStringManipulation::benchmark_bigrams);
    ClassDB::bind_method(D_METHOD("benchmark_split"), &CPPBenchmarkStringManipulation::benchmark_split);
    ClassDB::bind_method(D_METHOD("benchmark_rsplit"), &CPPBenchmarkStringManipulation::benchmark_rsplit);
    ClassDB::bind_method(D_METHOD("benchmark_split_floats"), &CPPBenchmarkStringManipulation::benchmark_split_floats);
    ClassDB::bind_method(D_METHOD("benchmark_pad_zeros_pre_constructed"), &CPPBenchmarkStringManipulation::benchmark_pad_zeros_pre_constructed);
    ClassDB::bind_method(D_METHOD("benchmark_pad_zeros"), &CPPBenchmarkStringManipulation::benchmark_pad_zeros);
    ClassDB::bind_method(D_METHOD("benchmark_pad_decimals_pre_constructed"), &CPPBenchmarkStringManipulation::benchmark_pad_decimals_pre_constructed);
    ClassDB::bind_method(D_METHOD("benchmark_pad_decimals"), &CPPBenchmarkStringManipulation::benchmark_pad_decimals);
    ClassDB::bind_method(D_METHOD("benchmark_lpad"), &CPPBenchmarkStringManipulation::benchmark_lpad);
    ClassDB::bind_method(D_METHOD("benchmark_rpad"), &CPPBenchmarkStringManipulation::benchmark_rpad);
    ClassDB::bind_method(D_METHOD("benchmark_similarity"), &CPPBenchmarkStringManipulation::benchmark_similarity);
    ClassDB::bind_method(D_METHOD("benchmark_simplify_path"), &CPPBenchmarkStringManipulation::benchmark_simplify_path);
    ClassDB::bind_method(D_METHOD("benchmark_capitalize"), &CPPBenchmarkStringManipulation::benchmark_capitalize);
    ClassDB::bind_method(D_METHOD("benchmark_to_snake_case"), &CPPBenchmarkStringManipulation::benchmark_to_snake_case);
    ClassDB::bind_method(D_METHOD("benchmark_to_camel_case"), &CPPBenchmarkStringManipulation::benchmark_to_camel_case);
    ClassDB::bind_method(D_METHOD("benchmark_to_pascal_case"), &CPPBenchmarkStringManipulation::benchmark_to_pascal_case);
    ClassDB::bind_method(D_METHOD("benchmark_to_lower"), &CPPBenchmarkStringManipulation::benchmark_to_lower);
    ClassDB::bind_method(D_METHOD("benchmark_uri_decode"), &CPPBenchmarkStringManipulation::benchmark_uri_decode);
    ClassDB::bind_method(D_METHOD("benchmark_uri_encode"), &CPPBenchmarkStringManipulation::benchmark_uri_encode);
    ClassDB::bind_method(D_METHOD("benchmark_xml_escape"), &CPPBenchmarkStringManipulation::benchmark_xml_escape);
    ClassDB::bind_method(D_METHOD("benchmark_xml_unescape"), &CPPBenchmarkStringManipulation::benchmark_xml_unescape);
    ClassDB::bind_method(D_METHOD("benchmark_humanize_size"), &CPPBenchmarkStringManipulation::benchmark_humanize_size);
    ClassDB::bind_method(D_METHOD("benchmark_is_valid_filename"), &CPPBenchmarkStringManipulation::benchmark_is_valid_filename);
    ClassDB::bind_method(D_METHOD("benchmark_validate_filename"), &CPPBenchmarkStringManipulation::benchmark_validate_filename);
    ClassDB::bind_method(D_METHOD("benchmark_validate_node_name"), &CPPBenchmarkStringManipulation::benchmark_validate_node_name);
    ClassDB::bind_method(D_METHOD("benchmark_casecmp_to"), &CPPBenchmarkStringManipulation::benchmark_casecmp_to);
    ClassDB::bind_method(D_METHOD("benchmark_nocasecmp_to"), &CPPBenchmarkStringManipulation::benchmark_nocasecmp_to);
    ClassDB::bind_method(D_METHOD("benchmark_naturalnocasecmp_to"), &CPPBenchmarkStringManipulation::benchmark_naturalnocasecmp_to);
    ClassDB::bind_method(D_METHOD("benchmark_to_utf8_buffer"), &CPPBenchmarkStringManipulation::benchmark_to_utf8_buffer);
    ClassDB::bind_method(D_METHOD("benchmark_to_utf16_buffer"), &CPPBenchmarkStringManipulation::benchmark_to_utf16_buffer);
    ClassDB::bind_method(D_METHOD("benchmark_to_utf32_buffer"), &CPPBenchmarkStringManipulation::benchmark_to_utf32_buffer);
    ClassDB::bind_method(D_METHOD("benchmark_to_wchar_buffer"), &CPPBenchmarkStringManipulation::benchmark_to_wchar_buffer);
}

void CPPBenchmarkStringManipulation::benchmark_begins_with() {
    for (int i = 0; i < iterations; i++)
		String("Godot Engine").begins_with("Godot");  // true
}

void CPPBenchmarkStringManipulation::benchmark_ends_with() {
    for (int i = 0; i < iterations; i++)
		String("Godot Engine").ends_with("Engine");  // true
}

void CPPBenchmarkStringManipulation::benchmark_count() {
    for (int i = 0; i < iterations; i++)
		String("Godot Engine").count("o");  // 2
}

void CPPBenchmarkStringManipulation::benchmark_countn() {
    for (int i = 0; i < iterations; i++)
		String("Godot Engine").countn("o");  // 2
}

void CPPBenchmarkStringManipulation::benchmark_contains() {
    for (int i = 0; i < iterations; i++)
		String("Godot Engine").contains("o");  // tr
}

void CPPBenchmarkStringManipulation::benchmark_find() {
	for (int i = 0; i < iterations; i++)
		String("Godot Engine").find("o");  // 1
}

void CPPBenchmarkStringManipulation::benchmark_findn() {
	for (int i = 0; i < iterations; i++)
		String("Godot Engine").findn("o");  // 1
}

void CPPBenchmarkStringManipulation::benchmark_rfind() {
	for (int i = 0; i < iterations; i++)
		String("Godot Engine").rfind("o");  // 3
}

void CPPBenchmarkStringManipulation::benchmark_rfindn() {
	for (int i = 0; i < iterations; i++)
		String("Godot Engine").rfindn("o");  // 3
}

void CPPBenchmarkStringManipulation::benchmark_substr() {
	for (int i = 0; i < iterations; i++)
		String("Hello Godot!").substr(6, 5);  // "Godot"
}

void CPPBenchmarkStringManipulation::benchmark_insert() {
	for (int i = 0; i < iterations; i++)
		String("Hello !").insert(6, "Godot");  // "Hello Godot!"
}

void CPPBenchmarkStringManipulation::benchmark_get_slice() {
	for (int i = 0; i < iterations; i++)
		String("1234,5678,90.12").get_slice(",", 1);  // "5678"
}

void CPPBenchmarkStringManipulation::benchmark_get_slice_count() {
	for (int i = 0; i < iterations; i++)
		String("1234,5678,90.12").get_slice_count(",");  // 3
}

void CPPBenchmarkStringManipulation::benchmark_bigrams() {
    for (int i = 0; i < iterations; i++)
		String("Godot Engine").bigrams();  // ["Go", "od", "do", "ot", "t ", " E", "En", "ng", "gi", "in", "ne"]
}

void CPPBenchmarkStringManipulation::benchmark_split() {
	for (int i = 0; i < iterations; i++)
		String("1234,5678,90.12").split(",");  //  ["1234", "5678", "90.12"]
}

void CPPBenchmarkStringManipulation::benchmark_rsplit() {
	for (int i = 0; i < iterations; i++)
		String("1234,5678,90.12").rsplit(",");  //  ["1234", "5678", "90.12"]
}

void CPPBenchmarkStringManipulation::benchmark_split_floats() {
	for (int i = 0; i < iterations; i++)
		String("1234,5678,90.12").split_floats(",");  //  [1234.0, 5678.0, 90.12]
}

void CPPBenchmarkStringManipulation::benchmark_pad_zeros_pre_constructed() {
	for (int i = 0; i < iterations; i++)
		String("12345").pad_zeros(7);  // "0012345"
}

void CPPBenchmarkStringManipulation::benchmark_pad_zeros() {
	for (int i = 0; i < iterations; i++)
		godot::UtilityFunctions::str(12345).pad_zeros(7);  // "0012345"
}

void CPPBenchmarkStringManipulation::benchmark_pad_decimals_pre_constructed() {
	for (int i = 0; i < iterations; i++)
		String("1234.5678").pad_decimals(2);  // "1234.56"
}

void CPPBenchmarkStringManipulation::benchmark_pad_decimals() {
	for (int i = 0; i < iterations; i++)
		godot::UtilityFunctions::str(1234.5678).pad_decimals(2);  // "1234.56"
}

void CPPBenchmarkStringManipulation::benchmark_lpad() {
	for (int i = 0; i < iterations; i++)
		String("Godot").lpad(7, "+");  // "++Godot"
}

void CPPBenchmarkStringManipulation::benchmark_rpad() {
	for (int i = 0; i < iterations; i++)
		String("Godot").rpad(7, "+");  // "Godot++"
}

void CPPBenchmarkStringManipulation::benchmark_similarity() {
	for (int i = 0; i < iterations; i++)
		String("Godot").similarity("Engine");
}

void CPPBenchmarkStringManipulation::benchmark_simplify_path() {
	for (int i = 0; i < iterations; i++)
		String("./path/to///../file").simplify_path();  // "path/file"
}

void CPPBenchmarkStringManipulation::benchmark_capitalize() {
	for (int i = 0; i < iterations; i++)
		String("godot_engine_demo").capitalize();  // "Godot Engine Demo"
}

void CPPBenchmarkStringManipulation::benchmark_to_snake_case() {
	for (int i = 0; i < iterations; i++)
		String("GodotEngineDemo").to_snake_case();  // "godot_engine_demo"
}

void CPPBenchmarkStringManipulation::benchmark_to_camel_case() {
	for (int i = 0; i < iterations; i++)
		String("godot_engine_demo").to_snake_case();  // "godotEngineDemo"
}

void CPPBenchmarkStringManipulation::benchmark_to_pascal_case() {
	for (int i = 0; i < iterations; i++)
		String("godot_engine_demo").to_pascal_case();  // "GodotEngineDemo"
}

void CPPBenchmarkStringManipulation::benchmark_to_lower() {
	for (int i = 0; i < iterations; i++)
		String("Godot Engine Demo").to_lower();  // "godot engine demo"
}

void CPPBenchmarkStringManipulation::benchmark_uri_decode() {
	for (int i = 0; i < iterations; i++)
		String("Godot%20Engine%3Adocs").uri_decode();  // "Godot Engine:docs"
}

void CPPBenchmarkStringManipulation::benchmark_uri_encode() {
	for (int i = 0; i < iterations; i++)
		String("Godot Engine:docs").uri_encode();  // "Godot%20Engine%3Adocs"
}

void CPPBenchmarkStringManipulation::benchmark_xml_escape() {
	for (int i = 0; i < iterations; i++)
		String("Godot Engine <&>").xml_escape();  // "Godot Engine &lt;&amp;&gt;"
}

void CPPBenchmarkStringManipulation::benchmark_xml_unescape() {
	for (int i = 0; i < iterations; i++)
		String("Godot Engine &lt;&amp;&gt;").xml_unescape();  // "Godot Engine <&>"
}

void CPPBenchmarkStringManipulation::benchmark_humanize_size() {
	for (int i = 0; i < iterations; i++)
		String::humanize_size(123456);  // 120.5 KB
}

void CPPBenchmarkStringManipulation::benchmark_is_valid_filename() {
	for (int i = 0; i < iterations; i++)
		String("Godot Engine: Demo.exe").is_valid_filename();  // false
}

void CPPBenchmarkStringManipulation::benchmark_validate_filename() {
	for (int i = 0; i < iterations; i++)
		String("Godot Engine: Demo.exe").validate_filename();  // "Godot Engine_ Demo.exe"
}

void CPPBenchmarkStringManipulation::benchmark_validate_node_name() {
	for (int i = 0; i < iterations; i++)
		String("TestNode:123456").validate_node_name();  // "TestNode123456"
}

void CPPBenchmarkStringManipulation::benchmark_casecmp_to() {
	for (int i = 0; i < iterations; i++)
		String("2 Example").casecmp_to("10 Example");  // 1
}

void CPPBenchmarkStringManipulation::benchmark_nocasecmp_to() {
	for (int i = 0; i < iterations; i++)
		String("2 Example").nocasecmp_to("10 Example");  // 1
}

void CPPBenchmarkStringManipulation::benchmark_naturalnocasecmp_to() {
	for (int i = 0; i < iterations; i++)
		String("2 Example").naturalnocasecmp_to("10 Example");  // -1
}

void CPPBenchmarkStringManipulation::benchmark_to_utf8_buffer() {
	for (int i = 0; i < iterations; i++)
		String("Godot Engine").to_utf8_buffer();
}

void CPPBenchmarkStringManipulation::benchmark_to_utf16_buffer() {
	for (int i = 0; i < iterations; i++)
		String("Godot Engine").to_utf16_buffer();
}

void CPPBenchmarkStringManipulation::benchmark_to_utf32_buffer() {
	for (int i = 0; i < iterations; i++)
		String("Godot Engine").to_utf32_buffer();
}

void CPPBenchmarkStringManipulation::benchmark_to_wchar_buffer() {
	for (int i = 0; i < iterations; i++)
		String("Godot Engine").to_wchar_buffer();
}

CPPBenchmarkStringManipulation::CPPBenchmarkStringManipulation() {}

CPPBenchmarkStringManipulation::~CPPBenchmarkStringManipulation() {}
