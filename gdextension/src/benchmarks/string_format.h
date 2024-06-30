#ifndef CPP_BENCHMARK_STRING_FORMAT_H
#define CPP_BENCHMARK_STRING_FORMAT_H

#include "../cppbenchmark.h"

namespace godot {
    class CPPBenchmarkStringFormat : public CPPBenchmark {
        GDCLASS(CPPBenchmarkStringFormat, CPPBenchmark)

        private:
            const String ENGINE_NAME = "Godot";
            Dictionary FORMAT_DICT;

            String engine_name = "Godot";
            int some_integer = 123456;
            float some_float = 1.2;
            Vector2i some_vector2i = Vector2i(12, 34);
        protected:
	        static void _bind_methods();
        public:
            unsigned int iterations = 1000000;
            void benchmark_no_op_constant_method();
            void benchmark_simple_constant_concatenate();
            void benchmark_simple_constant_percent();
            void benchmark_simple_constant_method();
            void benchmark_simple_constant_method_constant_dict();
            void benchmark_simple_variable_concatenate();
            void benchmark_simple_variable_percent();
            void benchmark_simple_variable_method();
            void benchmark_complex_variable_concatenate();
            void benchmark_complex_variable_percent();
            void benchmark_complex_variable_method();
            CPPBenchmarkStringFormat();
            ~CPPBenchmarkStringFormat();
    };
}
#endif
