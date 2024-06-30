#include "string_format.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void CPPBenchmarkStringFormat::_bind_methods() {
    ClassDB::bind_method(D_METHOD("benchmark_no_op_constant_method"), &CPPBenchmarkStringFormat::benchmark_no_op_constant_method);
    ClassDB::bind_method(D_METHOD("benchmark_simple_constant_concatenate"), &CPPBenchmarkStringFormat::benchmark_simple_constant_concatenate);
    ClassDB::bind_method(D_METHOD("benchmark_simple_constant_percent"), &CPPBenchmarkStringFormat::benchmark_simple_constant_percent);
    ClassDB::bind_method(D_METHOD("benchmark_simple_constant_method"), &CPPBenchmarkStringFormat::benchmark_simple_constant_method);
    ClassDB::bind_method(D_METHOD("benchmark_simple_constant_method_constant_dict"), &CPPBenchmarkStringFormat::benchmark_simple_constant_method_constant_dict);
    ClassDB::bind_method(D_METHOD("benchmark_simple_variable_concatenate"), &CPPBenchmarkStringFormat::benchmark_simple_variable_concatenate);
    ClassDB::bind_method(D_METHOD("benchmark_simple_variable_percent"), &CPPBenchmarkStringFormat::benchmark_simple_variable_percent);
    ClassDB::bind_method(D_METHOD("benchmark_simple_variable_method"), &CPPBenchmarkStringFormat::benchmark_simple_variable_method);
    ClassDB::bind_method(D_METHOD("benchmark_complex_variable_concatenate"), &CPPBenchmarkStringFormat::benchmark_complex_variable_concatenate);
    ClassDB::bind_method(D_METHOD("benchmark_complex_variable_percent"), &CPPBenchmarkStringFormat::benchmark_complex_variable_percent);
    ClassDB::bind_method(D_METHOD("benchmark_complex_variable_method"), &CPPBenchmarkStringFormat::benchmark_complex_variable_method);
}

void CPPBenchmarkStringFormat::benchmark_no_op_constant_method() {
    for (int i = 0; i < iterations; i++) {
        Dictionary dict;
        String("Hello nothing!").format(dict);
    }
}

void CPPBenchmarkStringFormat::benchmark_simple_constant_concatenate() {
    for (int i = 0; i < iterations; i++)
		"Hello " + ENGINE_NAME + "!";
}

void CPPBenchmarkStringFormat::benchmark_simple_constant_percent() {
	for (int i = 0; i < iterations; i++)
		String("Hello %s!") % ENGINE_NAME;
}

void CPPBenchmarkStringFormat::benchmark_simple_constant_method() {
	for (int i = 0; i < iterations; i++) {
        Dictionary dict;
        dict["engine"] = ENGINE_NAME;
		String("Hello {engine}!").format(dict);
    }
}

void CPPBenchmarkStringFormat::benchmark_simple_constant_method_constant_dict() {
	for (int i = 0; i < iterations; i++)
		String("Hello {engine}!").format(FORMAT_DICT);
}

void CPPBenchmarkStringFormat::benchmark_simple_variable_concatenate() {
	for (int i = 0; i < iterations; i++)
		"Hello " + engine_name + "!";
}

void CPPBenchmarkStringFormat::benchmark_simple_variable_percent() {
	for (int i = 0; i < iterations; i++)
		String("Hello %s!") % engine_name;
}

void CPPBenchmarkStringFormat::benchmark_simple_variable_method() {
	for (int i = 0; i < iterations; i++) {
        Dictionary dict;
        dict["engine"] = engine_name;
		String("Hello {engine}!").format(dict);
    }
}

void CPPBenchmarkStringFormat::benchmark_complex_variable_concatenate() {
    for (int i = 0; i < iterations; i++)
        "Hello " + engine_name + "!\nA few examples of formatting: " + godot::UtilityFunctions::str(some_integer) + ", " + godot::UtilityFunctions::str(some_float).pad_decimals(2) + ", " + godot::UtilityFunctions::str(some_vector2i);
}

void CPPBenchmarkStringFormat::benchmark_complex_variable_percent() {
    for (int i = 0; i < iterations; i++) {
        Array arr = Array::make(engine_name, some_integer, some_float, some_vector2i);
        String("Hello %s!\nA few examples of formatting: %d, %.2f, %v") % arr;
    }
}

void CPPBenchmarkStringFormat::benchmark_complex_variable_method() {
    for (int i = 0; i < iterations; i++) {
        Dictionary dict;
        dict["engine"] = engine_name;
        dict["an_integer"] = some_integer;
        dict["a_float"] = godot::UtilityFunctions::str(some_float).pad_decimals(2);
        dict["a_vector2i"] = some_vector2i;
		String("Hello {engine}!\nA few examples of formatting: {an_integer}, {a_float}, {a_vector2i}").format(dict);
    }
}

CPPBenchmarkStringFormat::CPPBenchmarkStringFormat() {
    FORMAT_DICT["engine"] = ENGINE_NAME;
}

CPPBenchmarkStringFormat::~CPPBenchmarkStringFormat() {}
