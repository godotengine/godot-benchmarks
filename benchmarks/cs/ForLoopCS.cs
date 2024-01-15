public partial class ForLoopCS : BenchmarkCS
{
    const int ITERATIONS = 1_000_000;

    public int number = 0;

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
