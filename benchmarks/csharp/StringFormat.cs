using Godot;
using System;
using System.Collections.Generic;

public partial class StringFormat : Benchmark
{

    const int ITERATIONS = 1_000_000;
    const string ENGINE_NAME = "Godot";
    Godot.Collections.Dictionary FORMAT_DICT = new Godot.Collections.Dictionary(){{"engine", ENGINE_NAME}};
    //Dictionary<string, string> FORMAT_DICT = new Dictionary<string, string>() {{"engine", engine_name}};

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
            String.Format("Hello {0}!", new Godot.Collections.Dictionary(){{"engine", ENGINE_NAME}}["engine"]);
        }
    }

    private void BenchmarkSimpleConstantMethodConstantDict() {
        for (int i = 0; i < ITERATIONS; i++) {
            String.Format("Hello {0}!", FORMAT_DICT["engine"]);
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
            String.Format("Hello {0}!", new Godot.Collections.Dictionary(){{"engine", engine_name}}["engine"]);
            //Dictionary<string, string> d = new Dictionary<string, string>() {{"engine", engine_name}};
            //String.Format("Hello {0}!", d["engine"]);
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
            Godot.Collections.Dictionary temp_dict = new Godot.Collections.Dictionary(){
                    {"engine", engine_name},
                    {"an_integer", some_integer},
                    {"a_float", some_float.ToString().PadDecimals(2)},
                    {"a_vector2i", some_vector2i},
            };
            String.Format(
                "Hello {0}!\nA few examples of formatting: {1}, {2}, {3}", temp_dict["engine"], temp_dict["an_integer"], temp_dict["a_float"], temp_dict["a_vector2i"]
            );
        }
    }
}
