using Godot;

public partial class BenchmarkCS : RefCounted
{
    // Kept snake_case for consistency and simplicity,
    // but could use the TestID.Language property to have language-dependent style if desired

    public bool test_render_cpu = false;
    public bool test_render_gpu = false;
    public bool test_idle = false;
    public bool test_physics = false;
}
