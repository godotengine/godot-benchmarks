using System.Collections.Generic;

// Similar to GDScript Array benchmarks, but using C# List instead

public partial class List : BenchmarkCS
{
    private const int ITERATIONS = 2_000_000;

    public void BenchmarkInt32List()
    {
        List<int> list = new List<int>();

        for(int i = 0; i < ITERATIONS; i++)
        { list.Add(i); }

        for(int i = 0; i < ITERATIONS; i++)
        { list[i] = 0; }

        for(int i = 0; i < ITERATIONS; i++)
        { list.RemoveAt(list.Count - 1); }
    }

    public void BenchmarkInt64List()
    {
        List<long> list = new List<long>();

        for(int i = 0; i < ITERATIONS; i++)
        { list.Add(i); }

        for(int i = 0; i < ITERATIONS; i++)
        { list[i] = 0; }

        for(int i = 0; i < ITERATIONS; i++)
        { list.RemoveAt(list.Count - 1); }
    }

    public void BenchmarkFloat32List()
    {
        List<float> list = new List<float>();

        for(int i = 0; i < ITERATIONS; i++)
        { list.Add(i); }

        for(int i = 0; i < ITERATIONS; i++)
        { list[i] = 0; }

        for(int i = 0; i < ITERATIONS; i++)
        { list.RemoveAt(list.Count - 1); }
    }

    public void BenchmarkFloat64List()
    {
        List<double> list = new List<double>();

        for(int i = 0; i < ITERATIONS; i++)
        { list.Add(i); }

        for(int i = 0; i < ITERATIONS; i++)
        { list[i] = 0; }

        for(int i = 0; i < ITERATIONS; i++)
        { list.RemoveAt(list.Count - 1); }
    }

    public void BenchmarkVector2List()
    {
        List<Godot.Vector2> list = new List<Godot.Vector2>();

        for(int i = 0; i < ITERATIONS; i++)
        { list.Add(new Godot.Vector2(i, i)); }

        for(int i = 0; i < ITERATIONS; i++)
        { list[i] = Godot.Vector2.Zero; }

        for(int i = 0; i < ITERATIONS; i++)
        { list.RemoveAt(list.Count - 1); }
    }

    public void BenchmarkVector3List()
    {
        List<Godot.Vector3> list = new List<Godot.Vector3>();

        for(int i = 0; i < ITERATIONS; i++)
        { list.Add(new Godot.Vector3(i, i, i)); }

        for(int i = 0; i < ITERATIONS; i++)
        { list[i] = Godot.Vector3.Zero; }

        for(int i = 0; i < ITERATIONS; i++)
        { list.RemoveAt(list.Count - 1); }
    }

    public void BenchmarkColorList()
    {
        List<Godot.Color> list = new List<Godot.Color>();

        for(int i = 0; i < ITERATIONS; i++)
        { list.Add(new Godot.Color(i, i, i, 1.0f)); }

        for(int i = 0; i < ITERATIONS; i++)
        { list[i] = Godot.Colors.Black; }

        for(int i = 0; i < ITERATIONS; i++)
        { list.RemoveAt(list.Count - 1); }
    }

    public void BenchmarkStringList()
    {
        List<string> list = new List<string>();

        for(int i = 0; i < ITERATIONS; i++)
        { list.Add("Godot " + i.ToString()); }

        for(int i = 0; i < ITERATIONS; i++)
        { list[i] = ""; }

        for(int i = 0; i < ITERATIONS; i++)
        { list.RemoveAt(list.Count - 1); }
    }
}