using Godot;
using System;

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

    private void BenchmarkNoOpConstantMethod() {
        for (int i = 0; i < ITERATIONS; i++) {
            String.Format("Hello nothing!", new Godot.Collections.Dictionary(){});
        }
    }

    private void BenchmarkSimpleConstantConcatenate() {
        for (int i = 0; i < ITERATIONS; i++) {
            string temp = "Hello " + ENGINE_NAME + "!";
        }
    }

    private void BenchmarkSimpleConstantPercent() {
        for (int i = 0; i < ITERATIONS; i++) {
            string temp = $"Hello {ENGINE_NAME}!";
        }
    }

    private void BenchmarkSimpleConstantMethod() {
        for (int i = 0; i < ITERATIONS; i++) {
            String.Format("Hello {engine}!", new Godot.Collections.Dictionary(){{"engine", ENGINE_NAME}});
        }
    }

    private void BenchmarkSimpleConstantMethodConstantDict() {
        for (int i = 0; i < ITERATIONS; i++) {
            String.Format("Hello {engine}!", FORMAT_DICT);
        }
    }

    private void BenchmarkSimpleVariableConcatenate() {
        for (int i = 0; i < ITERATIONS; i++) {
            string temp = "Hello " + engine_name + "!";
        }
    }

    private void BenchmarkSimpleVariablePercent() {
        for (int i = 0; i < ITERATIONS; i++) {
            string temp = $"Hello {engine_name}!";
        }
    }

    private void BenchmarkSimpleVariableMethod() {
        for (int i = 0; i < ITERATIONS; i++) {
            String.Format("Hello {engine}!", new Godot.Collections.Dictionary(){{"engine", engine_name}});
        }
    }

    private void BenchmarkComplexVariableConcatenate() {
        for (int i = 0; i < ITERATIONS; i++) {
            string temp = "Hello " + engine_name + "!\nA few examples of formatting: " + some_integer.ToString() + ", " + some_float.ToString().PadDecimals(2) + ", " + some_vector2i.ToString();
        }
    }

    private void BenchmarkComplexVariablePercent() {
        for (int i = 0; i < ITERATIONS; i++) {
            string temp = $"Hello {engine_name}!\nA few examples of formatting: {some_integer}, {some_float:F2}, {some_vector2i}";
        }
    }

    private void BenchmarkComplexVariableMethod() {
        for (int i = 0; i < ITERATIONS; i++) {
            String.Format("Hello {engine}!\nA few examples of formatting: {an_integer}, {a_float}, {a_vector2}", new Godot.Collections.Dictionary(){
                    {"engine", engine_name},
                    {"an_integer", some_integer},
                    {"a_float", some_float.ToString().PadDecimals(2)},
                    {"a_vector2i", some_vector2i},
            });
        }
    }
}
