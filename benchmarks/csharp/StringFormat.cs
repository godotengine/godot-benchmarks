using Godot;
using System;

public partial class StringFormat : Benchmark
{

    const int ITERATIONS = 1_000_000;
    const string ENGINE_NAME = "Godot";
    Godot.Collections.Dictionary FORMAT_DICT = new Godot.Collections.Dictionary(){{"engine", ENGINE_NAME}};

    string engineName = "Godot";
    int someInteger = 123456;
    float someFloat = 1.2F;
    Vector2I someVector2i = new Vector2I(12, 34);

    // Benchmark various ways to format strings.

    private void BenchmarkNoOpConstantMethod()
    {
        for (int i = 0; i < ITERATIONS; i++)
        {
            String.Format("Hello nothing!", new Godot.Collections.Dictionary(){});
        }
    }

    private void BenchmarkSimpleConstantConcatenate()
    {
        for (int i = 0; i < ITERATIONS; i++)
        {
            string temp = "Hello " + ENGINE_NAME + "!";
        }
    }

    private void BenchmarkSimpleConstantPercent()
    {
        for (int i = 0; i < ITERATIONS; i++)
        {
            string temp = $"Hello {ENGINE_NAME}!";
        }
    }

    private void BenchmarkSimpleConstantMethod() 
    {
        for (int i = 0; i < ITERATIONS; i++)
        {
            String.Format("Hello {0}!", new Godot.Collections.Dictionary(){{"engine", ENGINE_NAME}}["engine"]);
        }
    }

    private void BenchmarkSimpleConstantMethodConstantDict()
    {
        for (int i = 0; i < ITERATIONS; i++)
        {
            String.Format("Hello {0}!", FORMAT_DICT["engine"]);
        }
    }

    private void BenchmarkSimpleVariableConcatenate()
    {
        for (int i = 0; i < ITERATIONS; i++)
        {
            string temp = "Hello " + engineName + "!";
        }
    }

    private void BenchmarkSimpleVariablePercent()
    {
        for (int i = 0; i < ITERATIONS; i++)
        {
            string temp = $"Hello {engineName}!";
        }
    }

    private void BenchmarkSimpleVariableMethod()
    {
        for (int i = 0; i < ITERATIONS; i++)
        {
            String.Format("Hello {0}!", new Godot.Collections.Dictionary(){{"engine", engineName}}["engine"]);
        }
    }

    private void BenchmarkComplexVariableConcatenate()
    {
        for (int i = 0; i < ITERATIONS; i++)
        {
            string temp = "Hello " + engineName + "!\nA few examples of formatting: " + someInteger.ToString() + ", " + someFloat.ToString().PadDecimals(2) + ", " + someVector2i.ToString();
        }
    }

    private void BenchmarkComplexVariablePercent()
    {
        for (int i = 0; i < ITERATIONS; i++)
        {
            string temp = $"Hello {engineName}!\nA few examples of formatting: {someInteger}, {someFloat:F2}, {someVector2i}";
        }
    }

    private void BenchmarkComplexVariableMethod()
    {
        for (int i = 0; i < ITERATIONS; i++)
        {
            Godot.Collections.Dictionary tempDict = new Godot.Collections.Dictionary(){
                    {"engine", engineName},
                    {"an_integer", someInteger},
                    {"a_float", someFloat.ToString().PadDecimals(2)},
                    {"a_vector2i", someVector2i},
            };
            String.Format(
                "Hello {0}!\nA few examples of formatting: {1}, {2}, {3}", tempDict["engine"], tempDict["an_integer"], tempDict["a_float"], tempDict["a_vector2i"]
            );
        }
    }
}
