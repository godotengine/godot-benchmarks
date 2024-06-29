using Godot;

public partial class HelloWorld : Benchmark
{
    public void BenchmarkHelloWorld()
    {
        GD.Print("Hello world!");
    }
}
