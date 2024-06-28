using Godot;

public partial class Alloc : Benchmark
{
    const int ITERATIONS = 100_000;

    void BenchmarkDeepTree() {
        Node rt = new Node();
        for (int i = 0; i < ITERATIONS; i++) {
            Node n = new Node();
            n.AddChild(rt);
            rt = n;
        }

        // Avoid triggering a stack overflow with rt.free()
        while (rt.GetChildCount() != 0) {
            Node n = rt.GetChild(0);
            rt.RemoveChild(n);
            rt.Free();
            rt = n;
        }
        rt.Free();
    }

    void BenchmarkWideTree() {
        Node rt = new Node();
        for (int i = 0; i < ITERATIONS; i++) {
            rt.AddChild(new Node());
        }
        rt.Free();
    }

    void BenchmarkFragmentation() {
        Node top = new Node();
        for (int i = 0; i < 5; i++) {
            top.AddChild(new Node());
        }

        for (int k = 0; k < 10; k++) {
            for (int i = 0; i < ITERATIONS; i++) {
                // Attempt to scatter children in memory by assigning newly created nodes to a random parent
                int idx = (int)GD.Randi() % top.GetChildCount();
                top.GetChild(idx).AddChild(new Node());
            }

            Node tmp = top.GetChild(0);
            top.RemoveChild(tmp);
            // Since nodes in the tree are scattered in memory,
            // freeing subtrees this way should maximize fragmentation.
            tmp.Free();
            top.AddChild(new Node());
            //GD.Print("Iteration %d: %.3f MB" % [k, Performance.get_monitor(Performance.MEMORY_STATIC) / 1e6])
        }

        top.Free();
    }

    void BenchmarkDuplicate() {
        Node rt = new Node();
        for (int i = 0; i < 16; i++) {
            Node n = new Node();
            n.AddChild(rt.Duplicate());
            n.AddChild(rt.Duplicate());
            rt.Free();
            rt = n;
            //GD.Print("Iteration %d: %.3f MB" % [i, Performance.get_monitor(Performance.MEMORY_STATIC) / 1e6])
        }
        rt.Free();
    }
}