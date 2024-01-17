// Similar to GDScript Array benchmarks, but using C# Array instead

public partial class Array : BenchmarkCS
{
    public void BenchmarkFillLoop()
    {
        int[] array = new int[10_000_000];

        for(int i = 0; i < array.Length; i++)
        { array[i] = 1234; }
    }

    public void BenchmarkFillMethod()
    {
        int[] array = new int[10_000_000];
        System.Array.Fill(array, 1234);
    }
}
