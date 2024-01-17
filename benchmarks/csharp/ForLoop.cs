// Similar to GDScript for_loop benchmarks, but using C#

public partial class ForLoop : BenchmarkCS
{
    private const int ITERATIONS = 1_000_000;

    private int number = 0;

    public void BenchmarkLoopAdd()
    {
        for(int i = 0; i < ITERATIONS; i++)
        {
            number += 1;
        }
    }

    public void BenchmarkLoopCall()
    {
        for(int i = 0; i < ITERATIONS; i++)
        {
            Function();
        }
    }

    public virtual void Function(){}
}
