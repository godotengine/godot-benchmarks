using Godot.Collections;

// Similar to GDScript Array benchmarks, but using C# List instead

public partial class List : Benchmark
{
    private const int ITERATIONS = 2_000_000;

    public void BenchmarkEmptyList()
    {
        Array<int> list = new Array<int>();
        for (int i = 0; i < ITERATIONS; i++)
        { list.IndexOf(0); }
    }

    public void BenchmarkInt32List()
    {
        Array<int> list = new Array<int>();

        for(int i = 0; i < ITERATIONS; i++)
        { list.Add(i); }

        for(int i = 0; i < ITERATIONS; i++)
        { list[i] = 0; }

        for(int i = 0; i < ITERATIONS; i++)
        { list.RemoveAt(list.Count - 1); }
    }

    public void BenchmarkInt64List()
    {
        Array<long> list = new Array<long>();

        for(int i = 0; i < ITERATIONS; i++)
        { list.Add(i); }

        for(int i = 0; i < ITERATIONS; i++)
        { list[i] = 0; }

        for(int i = 0; i < ITERATIONS; i++)
        { list.RemoveAt(list.Count - 1); }
    }

    public void BenchmarkFloat32List()
    {
        Array<float> list = new Array<float>();

        for(int i = 0; i < ITERATIONS; i++)
        { list.Add(i); }

        for(int i = 0; i < ITERATIONS; i++)
        { list[i] = 0; }

        for(int i = 0; i < ITERATIONS; i++)
        { list.RemoveAt(list.Count - 1); }
    }

    public void BenchmarkFloat64List()
    {
        Array<double> list = new Array<double>();

        for(int i = 0; i < ITERATIONS; i++)
        { list.Add(i); }

        for(int i = 0; i < ITERATIONS; i++)
        { list[i] = 0; }

        for(int i = 0; i < ITERATIONS; i++)
        { list.RemoveAt(list.Count - 1); }
    }

    public void BenchmarkVector2List()
    {
        Array<Godot.Vector2> list = new Array<Godot.Vector2>();

        for(int i = 0; i < ITERATIONS; i++)
        { list.Add(new Godot.Vector2(i, i)); }

        for(int i = 0; i < ITERATIONS; i++)
        { list[i] = Godot.Vector2.Zero; }

        for(int i = 0; i < ITERATIONS; i++)
        { list.RemoveAt(list.Count - 1); }
    }

    public void BenchmarkVector3List()
    {
        Array<Godot.Vector3> list = new Array<Godot.Vector3>();

        for(int i = 0; i < ITERATIONS; i++)
        { list.Add(new Godot.Vector3(i, i, i)); }

        for(int i = 0; i < ITERATIONS; i++)
        { list[i] = Godot.Vector3.Zero; }

        for(int i = 0; i < ITERATIONS; i++)
        { list.RemoveAt(list.Count - 1); }
    }

    public void BenchmarkColorList()
    {
        Array<Godot.Color> list = new Array<Godot.Color>();

        for(int i = 0; i < ITERATIONS; i++)
        { list.Add(new Godot.Color(i, i, i, 1.0f)); }

        for(int i = 0; i < ITERATIONS; i++)
        { list[i] = Godot.Colors.Black; }

        for(int i = 0; i < ITERATIONS; i++)
        { list.RemoveAt(list.Count - 1); }
    }

    public void BenchmarkStringList()
    {
        Array<string> list = new Array<string>();

        for(int i = 0; i < ITERATIONS; i++)
        { list.Add("Godot " + i.ToString()); }

        for(int i = 0; i < ITERATIONS; i++)
        { list[i] = ""; }

        for(int i = 0; i < ITERATIONS; i++)
        { list.RemoveAt(list.Count - 1); }
    }
}
