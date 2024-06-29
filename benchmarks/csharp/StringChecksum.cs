using Godot;

public partial class StringChecksum : Benchmark
{

    const int ITERATIONS = 1_000_000;
    const string LOREM_IPSUM = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";

    // Benchmark computation of checksums on a string.

    private void BenchmarkMd5BufferEmpty() {
        for (int i = 0; i < ITERATIONS; i++)
            "".Md5Buffer();
    }


    private void BenchmarkMd5BufferNonEmpty() {
        for (int i = 0; i < ITERATIONS; i++)
            LOREM_IPSUM.Md5Buffer();
    }


    private void BenchmarkSha1BufferEmpty() {
        for (int i = 0; i < ITERATIONS; i++)
            "".Sha1Buffer();
    }


    private void BenchmarkSha1BufferNonEmpty() {
        for (int i = 0; i < ITERATIONS; i++)
            LOREM_IPSUM.Sha1Buffer();
    }


    private void BenchmarkSha256BufferEmpty() {
        for (int i = 0; i < ITERATIONS; i++)
            "".Sha256Buffer();
    }


    private void BenchmarkSha256BufferNonEmpty() {
        for (int i = 0; i < ITERATIONS; i++)
            LOREM_IPSUM.Sha256Buffer();
    }


    private void BenchmarkMd5TextEmpty() {
        for (int i = 0; i < ITERATIONS; i++)
            "".Md5Text();
    }


    private void BenchmarkMd5TextNonEmpty() {
        for (int i = 0; i < ITERATIONS; i++)
            LOREM_IPSUM.Md5Text();
    }


    private void BenchmarkSha1TextEmpty() {
        for (int i = 0; i < ITERATIONS; i++)
            "".Sha1Text();
    }


    private void BenchmarkSha1TextNonEmpty() {
        for (int i = 0; i < ITERATIONS; i++)
            LOREM_IPSUM.Sha1Text();
    }


    private void BenchmarkSha256TextEmpty() {
        for (int i = 0; i < ITERATIONS; i++)
            "".Sha256Text();
    }


    private void BenchmarkSha256TextNonEmpty() {
        for (int i = 0; i < ITERATIONS; i++)
            LOREM_IPSUM.Sha256Text();
    }
}
