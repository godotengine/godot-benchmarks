using System;

public partial class LambdaPerformance : Benchmark
{
    const int ITERATIONS = 1_000_000;
    Action lambda = () => { };

    public void BenchmarkLambdaCall()
    {
        for(int i = 0; i < ITERATIONS; i++)
        {
            lambda();
        }
    }
}
