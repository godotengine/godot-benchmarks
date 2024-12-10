#include "register_types.h"

#include "benchmarks/alloc.h"
#include "benchmarks/array.h"
#include "benchmarks/binary_trees.h"
#include "benchmarks/control.h"
#include "benchmarks/forloop.h"
#include "benchmarks/hello_world.h"
#include "benchmarks/lambda_performance.h"
#include "benchmarks/mandelbrot_set.h"
#include "benchmarks/merkle_trees.h"
#include "benchmarks/nbody.h"
#include "benchmarks/spectral_norm.h"
#include "benchmarks/string_checksum.h"
#include "benchmarks/string_format.h"
#include "benchmarks/string_manipulation.h"

#include <gdextension_interface.h>
#include <godot_cpp/core/defs.hpp>
#include <godot_cpp/godot.hpp>

using namespace godot;

void initialize_benchmark_module(ModuleInitializationLevel p_level) {
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}

	GDREGISTER_CLASS(CPPBenchmark);
	GDREGISTER_CLASS(CPPBenchmarkAlloc);
	GDREGISTER_CLASS(CPPBenchmarkArray);
	GDREGISTER_CLASS(CPPBenchmarkBinaryTrees);
	GDREGISTER_CLASS(CPPBenchmarkControl);
	GDREGISTER_CLASS(CPPBenchmarkForLoop);
	GDREGISTER_CLASS(CPPBenchmarkHelloWorld);
	GDREGISTER_CLASS(CPPBenchmarkLambdaPerformance);
	GDREGISTER_CLASS(CPPBenchmarkMandelbrotSet);
	GDREGISTER_CLASS(CPPBenchmarkMerkleTrees);
	GDREGISTER_CLASS(CPPBenchmarkNbody);
	GDREGISTER_CLASS(CPPBenchmarkSpectralNorm);
	GDREGISTER_CLASS(CPPBenchmarkStringChecksum);
	GDREGISTER_CLASS(CPPBenchmarkStringFormat);
	GDREGISTER_CLASS(CPPBenchmarkStringManipulation);
}

void uninitialize_benchmark_module(ModuleInitializationLevel p_level) {
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}
}

extern "C" {
// Initialization.
GDExtensionBool GDE_EXPORT benchmark_library_init(GDExtensionInterfaceGetProcAddress p_get_proc_address, const GDExtensionClassLibraryPtr p_library, GDExtensionInitialization *r_initialization) {
	GDExtensionBinding::InitObject init_obj(p_get_proc_address, p_library, r_initialization);

	init_obj.register_initializer(initialize_benchmark_module);
	init_obj.register_terminator(uninitialize_benchmark_module);
	init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

	return init_obj.init();
}
}
