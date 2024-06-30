#ifndef CPP_BENCHMARK_FOR_LOOP_H
#define CPP_BENCHMARK_FOR_LOOP_H

#include "../cppbenchmark.h"

namespace godot {
    class CPPBenchmarkForLoop : public CPPBenchmark {
        GDCLASS(CPPBenchmarkForLoop, CPPBenchmark)

        private:
            void function();
        protected:
	        static void _bind_methods();
        public:
            unsigned int iterations = 1000000;
            void benchmark_loop_add();
            void benchmark_loop_call();
            CPPBenchmarkForLoop();
            ~CPPBenchmarkForLoop();
    };
}
#endif