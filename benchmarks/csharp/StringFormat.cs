using Godot;

public partial class StringFormat : Benchmark
{

    const int ITERATIONS = 1_000_000;
    const string ENGINE_NAME = "Godot";
    Godot.Collections.Dictionary FORMAT_DICT = new Godot.Collections.Dictionary(){{"engine", ENGINE_NAME}};

    string engine_name = "Godot";
    int some_integer = 123456;
    float some_float = 1.2F;
    Vector2I some_vector2i = new Vector2I(12, 34);

    // Benchmark various ways to format strings.

    private void benchmark_no_op_constant_method() {
        for (int i = 0; i < ITERATIONS; i++)
            "Hello nothing!".Format(new Godot.Collections.Dictionary(){});
    }

    private void benchmark_simple_constant_concatenate() {
        for (int i = 0; i < ITERATIONS; i++)
            "Hello " + ENGINE_NAME + "!";
    }

    private void benchmark_simple_constant_percent() {
        for (int i = 0; i < ITERATIONS; i++)
            "Hello %s!" % ENGINE_NAME;
    }

    private void benchmark_simple_constant_method() {
        for (int i = 0; i < ITERATIONS; i++)
            "Hello {engine}!".Format(new Godot.Collections.Dictionary(){{"engine", ENGINE_NAME}});
    }

    private void benchmark_simple_constant_method_constant_dict() {
        for (int i = 0; i < ITERATIONS; i++)
            "Hello {engine}!".Format(FORMAT_DICT);
    }

    private void benchmark_simple_variable_concatenate() {
        for (int i = 0; i < ITERATIONS; i++)
            "Hello " + engine_name + "!";
    }

    private void benchmark_simple_variable_percent() {
        for (int i = 0; i < ITERATIONS; i++)
            "Hello %s!" % engine_name;
    }

    private void benchmark_simple_variable_method() {
        for (int i = 0; i < ITERATIONS; i++)
            "Hello {engine}!".Format(new Godot.Collections.Dictionary(){{engine = engine_name}});
    }

    private void benchmark_complex_variable_concatenate() {
        for (int i = 0; i < ITERATIONS; i++)
            "Hello " + engine_name + "!\nA few examples of formatting: " + str(some_integer) + ", " + str(some_float).PadDecimals(2) + ", " + str(some_vector2i);
    }

    private void benchmark_complex_variable_percent() {
        for (int i = 0; i < ITERATIONS; i++)
            "Hello %s!\nA few examples of formatting: %d, %.2f, %v" % [engine_name, some_integer, some_float, some_vector2i];
    }

    private void benchmark_complex_variable_method() {
        for (int i = 0; i < ITERATIONS; i++) {
            "Hello {engine}!\nA few examples of formatting: {an_integer}, {a_float}, {a_vector2}".Format(new Godot.Collections.Dictionary(){
                    {engine = engine_name},
                    {an_integer = some_integer},
                    {a_float = str(some_float).PadDecimals(2)},
                    {a_vector2i = some_vector2i},
            });
        }
    }
}
