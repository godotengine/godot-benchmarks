using Godot;

public partial class SpectralNorm : Benchmark
{
    // Based on https://github.com/hanabi1224/Programming-Language-Benchmarks/blob/main/bench/algorithm/spectral-norm/3.cs
    // Return element i,j of infinite matrix A.
    private double eval_A(int i, int j)
    {
        return 1.0 / ((i + j) * (i + j + 1) / 2 + i + 1);
    }

    // multiply vector v by matrix A, each thread evaluate its range only.
    private void MultiplyAv(double[] v, double[] Av, int n)
    {
        for (int i = 0; i < n; i++)
        {
            double sum = 0;
            for (int j = 0; j < v.Length; j++)
                sum += eval_A(i, j) * v[j];

            Av[i] = sum;
        }
    }

    // multiply vector v by matrix A transposed.
    private void MultiplyAtv(double[] v, double[] Atv, int n)
    {
        for (int i = 0; i < n; i++)
        {
            double sum = 0;
            for (int j = 0; j < v.Length; j++)
                sum += eval_A(j, i) * v[j];

            Atv[i] = sum;
        }
    }

    // Multiply vector v by matrix A and then by matrix A transposed.
    private void MultiplyAtAv(double[] v, double[] tmp, double[] AtAv, int n)
    {
        MultiplyAv(v, tmp, n);
        MultiplyAtv(tmp, AtAv, n);
    }

    private void CalculateSpectralNorm(int n)
    {
        double[] u = new double[n];
        double[] v = new double[n];
        double[] tmp = new double[n];

        // Create unit vector.
        for (int i = 0; i < n; i++)
            u[i] = 1.0;

        for (int i = 0; i < 10; i++)
        {
            MultiplyAtAv(u, v, tmp, n);
            MultiplyAtAv(v, u, tmp, n);
        }

        double vBv = 0, vv = 0;
        for (int i = 0; i < n; i++)
        {
            vBv += u[i] * v[i];
            vv += v[i] * v[i];
        }

        double square_root = Mathf.Sqrt(vBv / vv);
        GD.Print("{0:f9}", square_root);
    }
    
    public void BenchmarkSpectralNorm100()
    {
        CalculateSpectralNorm(100);
    }

    public void BenchmarkSpectralNorm500()
    {
        CalculateSpectralNorm(500);
    }

    public void BenchmarkSpectralNorm1000()
    {
        CalculateSpectralNorm(1000);
    }

}
