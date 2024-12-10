#ifndef CPP_BENCHMARK_H
#define CPP_BENCHMARK_H

#include <godot_cpp/classes/ref_counted.hpp>

namespace godot {

class CPPBenchmark : public RefCounted {
	GDCLASS(CPPBenchmark, RefCounted)

protected:
	static void _bind_methods();
	int benchmark_time = 5e6;
	bool test_render_cpu = false;
	bool test_render_gpu = false;
	bool test_idle = false;
	bool test_physics = false;

public:
	void set_benchmark_time(const int p_benchmark_time);
	int get_benchmark_time() const;
	void set_test_render_cpu(const bool p_test_render_cpu);
	bool get_test_render_cpu() const;
	void set_test_render_gpu(const bool p_test_render_gpu);
	bool get_test_render_gpu() const;
	void set_test_idle(const bool p_test_idle);
	bool get_test_idle() const;
	void set_test_physics(const bool p_test_physics);
	bool get_test_physics() const;

	CPPBenchmark();
	~CPPBenchmark();
};

} // namespace godot

#endif
