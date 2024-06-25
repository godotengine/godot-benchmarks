using Godot;

public partial class Benchmark : RefCounted
{
    public double benchmark_time = 5e6;
    public bool test_render_cpu = false;
    public bool test_render_gpu = false;
    public bool test_idle = false;
    public bool test_physics = false;
}
