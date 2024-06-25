using Godot;

public partial class MandelbrotSet : Benchmark
{
    const int WIDTH = 600;
    const int HEIGHT = 400;
    const int MAX_ITERATION = 1000;

    private Color HSV(float hue, float sat, float value)
    {
        hue = Mathf.PosMod(hue, 360.0f);
        int h = Mathf.FloorToInt(hue) / 60;
        float f = hue / 60.0f - h;
        float p = value * (1.0f - sat);
        float q = value * (1.0f - sat * f);
        float t = value * (1.0f - sat * (1.0f - f));
        if (h == 0 || h == 6)
            return new Color(value, t, p);
        if (h == 1)
            return new Color(q, value, p);
        if (h == 2)
            return new Color(p, value, t);
        if (h == 3)
            return new Color(p, q, value);
        if (h == 4)
            return new Color(t, p, value);
        return new Color(value, p, q);
    }

    // Algorithm from
    // https://en.wikipedia.org/wiki/Plotting_algorithms_for_the_Mandelbrot_set#Optimized_escape_time_algorithms
    private void mandelbrot_set(int width, int height, int max_iteration)
    {
        Image image = Image.CreateEmpty(width, height, false, Image.Format.Rgb8);
        float ratio = (float)width / (float)height;
        float x_range = 3.6f;
        float y_range = x_range / ratio;
        float min_x = -x_range / 2.0f;
        float max_y = y_range / 2.0f;
        for (int x = 0; x < image.GetWidth(); x++)
        {
            for (int y = 0; y < image.GetHeight(); y++)
            {
                int iteration = 0;
                float x0 = min_x + x_range * x / width;
                float y0 = max_y - y_range * y / height;
                float xx = 0.0f;
                float yy = 0.0f;
                float x2 = 0.0f;
                float y2 = 0.0f;
                while (x2 + y2 <= 4 && iteration < max_iteration)
                {
                    yy = 2 * xx * yy + y0;
                    xx = x2 - y2 + x0;
                    x2 = xx * xx;
                    y2 = yy * yy;
                    iteration += 1;
                }
                float m = (float)iteration / (float)max_iteration;
                Color color = HSV(360.0f * m, 1.0f, Mathf.Ceil(1.0f - 1.1f * m));
                image.SetPixel(x, y, color);
            }
        }
    }

    public void BenchmarkMandelbrotSet()
    {
        mandelbrot_set(WIDTH, HEIGHT, MAX_ITERATION);
    }
}
