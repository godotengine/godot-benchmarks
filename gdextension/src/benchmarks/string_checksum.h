#ifndef CPP_BENCHMARK_STRING_CHECKSUM_H
#define CPP_BENCHMARK_STRING_CHECKSUM_H

#include "../cppbenchmark.h"

namespace godot {
    class CPPBenchmarkStringChecksum : public CPPBenchmark {
        GDCLASS(CPPBenchmarkStringChecksum, CPPBenchmark)

        private:
            const String LOREM_IPSUM = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
        protected:
	        static void _bind_methods();
        public:
            unsigned int iterations = 1000000;
            void benchmark_md5_buffer_empty();
            void benchmark_md5_buffer_non_empty();
            void benchmark_sha1_buffer_empty();
            void benchmark_sha1_buffer_non_empty();
            void benchmark_sha256_buffer_empty();
            void benchmark_sha256_buffer_non_empty();
            void benchmark_md5_text_empty();
            void benchmark_md5_text_non_empty();
            void benchmark_sha1_text_empty();
            void benchmark_sha1_text_non_empty();
            void benchmark_sha256_text_empty();
            void benchmark_sha256_text_non_empty();
            CPPBenchmarkStringChecksum();
            ~CPPBenchmarkStringChecksum();
    };
}
#endif
