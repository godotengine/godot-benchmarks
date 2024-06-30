#ifndef BENCHMARK_REGISTER_TYPES_H
#define BENCHMARK_REGISTER_TYPES_H

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void initialize_benchmark_module(ModuleInitializationLevel p_level);
void uninitialize_benchmark_module(ModuleInitializationLevel p_level);

#endif // BENCHMARK_REGISTER_TYPES_H
