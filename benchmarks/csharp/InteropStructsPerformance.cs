using Godot;
using System;
using Godot.Collections;

public partial class InteropStructsPerformance : Benchmark
{
    private ulong frameCount;
    private ulong elapsed;
    private ulong firstFrameTime;
    private ulong averageDrawTime;
    private ulong peakDrawTime;
    private ulong peakMemory;
    private ulong averageMemory;
    private ulong start;

    private void OnDrawFinish()
    {
        var stop = Time.GetTicksMsec();
        elapsed += stop - start;

        ulong totalMemory = (ulong)GC.GetTotalMemory(false);
        peakMemory = Math.Max(totalMemory, peakMemory);
        if (frameCount == 1)
        {
            averageMemory = totalMemory;
        }
        else
        {
            averageMemory = averageMemory * (frameCount - 1) / frameCount + totalMemory / frameCount;
        }

        averageDrawTime = elapsed / frameCount;
        peakDrawTime = Math.Max(stop - start, peakDrawTime);

        if (stop - firstFrameTime >= 1000) // output every second
        {
            GD.Print($"GC usage: {totalMemory / (1024 * 1024)}Mb ({totalMemory}), average {averageMemory / (1024 * 1024)}Mb ({averageMemory}). Total frames:{frameCount} draw time: {stop - start}ms. average: {averageDrawTime}ms. peak: {peakDrawTime}ms");
            firstFrameTime = Time.GetTicksMsec();
        }
    }

    private void OnDrawStart()
    {
        GC.Collect();
        GC.Collect();

        frameCount++;
        if (firstFrameTime == 0)
        {
            firstFrameTime = Time.GetTicksMsec();
        }

        start = Time.GetTicksMsec();
    }

    public Node2D BenchmarkIndexOfEmptyArray()
    {
        benchmark_time = 5e6; // 5 seconds
        test_idle = true;

        Array<int> list = new Array<int>();

        var scene = new CSharpScene(
            ready: () => {},
            draw: amount => {
                OnDrawStart();

                for (var i = 0; i < amount; i++)
                {
                    // forces a call to Count when it checks if the list is empty
                    _ = list.IndexOf(0);
                }

                OnDrawFinish();
            },
            exit: () => {
                GD.Print($"GC average usage: {averageMemory / (1024 * 1024)}Mb ({averageMemory}). GC peak: {peakMemory / (1024 * 1024)}Mb ({peakMemory}). Average Draw() time: {averageDrawTime}ms. Peak Draw() time: {peakDrawTime}ms");
            },
            1_000_000);
        return scene;
    }

    public Node2D BenchmarkIndexOfNonEmptyArray()
    {
        benchmark_time = 5e6; // 5 seconds
        test_idle = true;

        Array<int> list = new Array<int>();
        list.Add(0);

        var scene = new CSharpScene(
            ready: () => {},
            draw: amount => {
                OnDrawStart();

                for (var i = 0; i < amount; i++)
                {
                    // does an interop call
                    _ = list.IndexOf(0);
                }

                OnDrawFinish();
            },
            exit: () => {
                GD.Print($"GC average usage: {averageMemory / (1024 * 1024)}Mb ({averageMemory}). GC peak: {peakMemory / (1024 * 1024)}Mb ({peakMemory}). Average Draw() time: {averageDrawTime}ms. Peak Draw() time: {peakDrawTime}ms");
            },
            1_000_000);
        return scene;
    }

}

public partial class CSharpScene : Node2D
{
    private readonly Action onReady;
    private readonly Action<int> onDraw;
    private readonly Action onExit;
    private readonly int amount;


    public CSharpScene(Action ready, Action<int> draw, Action exit, int amount) : base()
    {
        this.onReady = ready;
        this.onDraw = draw;
        this.onExit = exit;
        this.amount = amount;
    }

    public override void _Ready()
    {
        onReady();
        SetProcess(true);
    }

    public override void _Process(double delta)
    {
        QueueRedraw();
    }

    public override void _ExitTree()
    {
        onExit();
    }

    public override void _Draw()
    {
        onDraw(amount);
    }
}

// Potentially useful large and small objects to stress test the gc, not used right now.
internal partial class LargeGC : RefCounted
{
    const int SIZE = 10625; //85 KB

    public double[] d;
    public SmallGC m_pSmall;

    public LargeGC()
    {
        d = new double[SIZE];
        m_pSmall = null;
    }

    public virtual void AttachSmallObjects(SmallGC small)
    {
        m_pSmall = small;
    }
}

internal class SmallGC : RefCounted
{
    public LargeGC m_pLarge;

    public SmallGC(int HasLargeObj)
    {
        if (HasLargeObj == 1)
            m_pLarge = new LargeGC();
        else
            m_pLarge = null;
    }

    public virtual void AttachSmallObjects()
    {
        m_pLarge.AttachSmallObjects(this);
    }
}
