// Similar to GDScript Array benchmarks, but using C# Array instead

public partial class Array : Benchmark
{
    public void BenchmarkFillLoop()
    {
        Godot.Collections.Array<int> array = new Godot.Collections.Array<int>();
        array.Resize(10_000_000);

        for (int i = 0; i < array.Count; i++)
        {
            array[i] = 1234;
        }
    }

    public void BenchmarkFillMethod()
    {
        Godot.Collections.Array<int> array = new Godot.Collections.Array<int>();
        array.Resize(10_000_000);
        array.Fill(1234);
    }
}
