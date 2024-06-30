#ifndef CPP_BENCHMARK_HELLOWORLD_H
#define CPP_BENCHMARK_HELLOWORLD_H

#include "../cppbenchmark.h"

namespace godot {
    class CPPBenchmarkHelloWorld : public CPPBenchmark {
        GDCLASS(CPPBenchmarkHelloWorld, CPPBenchmark)

        protected:
	        static void _bind_methods();
        public:
            void benchmark_hello_world();
            CPPBenchmarkHelloWorld();
            ~CPPBenchmarkHelloWorld();
    };
}
#endif