using Godot;
using System;

public partial class StringManipulation : Benchmark
{

    const int ITERATIONS = 1_000_000;

    // Benchmark various ways to modify strings.

    private void BenchmarkBeginsWith() {
        for (int i = 0; i < ITERATIONS; i++)
            "Godot Engine".StartsWith("Godot");  // true
    }


    private void BenchmarkEndsWith() {
        for (int i = 0; i < ITERATIONS; i++)
            "Godot Engine".EndsWith("Engine");  // true
    }


    private void BenchmarkCount() {
        for (int i = 0; i < ITERATIONS; i++)
            StringExtensions.Count("Godot Engine", "o");  // 2
    }


    private void BenchmarkCountn() {
        for (int i = 0; i < ITERATIONS; i++)
            StringExtensions.CountN("Godot Engine", "o");  // 2
    }


    private void BenchmarkContains() {
        for (int i = 0; i < ITERATIONS; i++)
            "Godot Engine".Contains("o");  // true
    }

    private void BenchmarkFind() {
        for (int i = 0; i < ITERATIONS; i++)
            StringExtensions.Find("Godot Engine", "o");  // 1
    }


    private void BenchmarkFindn() {
        for (int i = 0; i < ITERATIONS; i++)
            StringExtensions.FindN("Godot Engine", "o");  // 1
    }


    private void BenchmarkRfind() {
        for (int i = 0; i < ITERATIONS; i++)
            StringExtensions.RFind("Godot Engine", "o");  // 3
    }


    private void BenchmarkRfindn() {
        for (int i = 0; i < ITERATIONS; i++)
            StringExtensions.RFindN("Godot Engine", "o");  // 3
    }


    private void BenchmarkSubstr() {
        for (int i = 0; i < ITERATIONS; i++)
            "Hello Godot!".Substr(6, 5);  // "Godot"
    }


    private void BenchmarkInsert() {
        for (int i = 0; i < ITERATIONS; i++)
            "Hello !".Insert(6, "Godot");  // "Hello Godot!"
    }


    private void BenchmarkBigrams() {
        for (int i = 0; i < ITERATIONS; i++)
            "Godot Engine".Bigrams();  // ["Go", "od", "do", "ot", "t ", " E", "En", "ng", "gi", "in", "ne"]
    }


    private void BenchmarkSplit() {
        for (int i = 0; i < ITERATIONS; i++)
            "1234,5678,90.12".Split(",");  //  ["1234", "5678", "90.12"]
    }


    private void BenchmarkSplitFloats() {
        for (int i = 0; i < ITERATIONS; i++)
            "1234,5678,90.12".SplitFloats(",");  //  [1234.0, 5678.0, 90.12]
    }


    private void BenchmarkPadZerosPreConstructed() {
        for (int i = 0; i < ITERATIONS; i++)
            "12345".PadZeros(7);  // "0012345"
    }


    private void BenchmarkPadZeros() {
        for (int i = 0; i < ITERATIONS; i++)
            12345.ToString().PadZeros(7);  // "0012345"
    }


    private void BenchmarkPadDecimalsPreConstructed() {
        for (int i = 0; i < ITERATIONS; i++)
            "1234.5678".PadDecimals(2);  // "1234.56"
    }


    private void BenchmarkPadDecimals() {
        for (int i = 0; i < ITERATIONS; i++)
            1234.5678.ToString().PadDecimals(2);  // "1234.56"
    }


    private void BenchmarkLpad() {
        for (int i = 0; i < ITERATIONS; i++)
            "Godot".PadLeft(7, '+');  // "++Godot"
    }


    private void BenchmarkRpad() {
        for (int i = 0; i < ITERATIONS; i++)
            "Godot".PadRight(7, '+');  // "Godot++"
    }


    private void BenchmarkSimilarity() {
        for (int i = 0; i < ITERATIONS; i++)
            "Godot".Similarity("Engine");
    }


    private void BenchmarkSimplifyPath() {
        for (int i = 0; i < ITERATIONS; i++)
            "./path/to///../file".SimplifyPath();  // "path/file"
    }


    private void BenchmarkCapitalize() {
        for (int i = 0; i < ITERATIONS; i++)
            "godot_engine_demo".Capitalize();  // "Godot Engine Demo"
    }


    private void BenchmarkToSnakeCase() {
        for (int i = 0; i < ITERATIONS; i++)
            "GodotEngineDemo".ToSnakeCase();  // "godot_engine_demo"
    }


    private void BenchmarkToCamelCase() {
        for (int i = 0; i < ITERATIONS; i++)
            "godot_engine_demo".ToSnakeCase();  // "godotEngineDemo"
    }


    private void BenchmarkToPascalCase() {
        for (int i = 0; i < ITERATIONS; i++)
            "godot_engine_demo".ToPascalCase();  // "GodotEngineDemo"
    }


    private void BenchmarkToLower() {
        for (int i = 0; i < ITERATIONS; i++)
            "Godot Engine Demo".ToLower();  // "godot engine demo"
    }


    private void BenchmarkUriDecode() {
        for (int i = 0; i < ITERATIONS; i++)
            StringExtensions.URIDecode("Godot%20Engine%3Adocs");  // "Godot Engine:docs"
    }


    private void BenchmarkUriEncode() {
        for (int i = 0; i < ITERATIONS; i++)
            StringExtensions.URIEncode("Godot Engine:docs");  // "Godot%20Engine%3Adocs"
    }


    private void BenchmarkXmlEscape() {
        for (int i = 0; i < ITERATIONS; i++)
            StringExtensions.XMLEscape("Godot Engine <&>");  // "Godot Engine &lt;&amp;&gt;"
    }


    private void BenchmarkXmlUnescape() {
        for (int i = 0; i < ITERATIONS; i++)
            StringExtensions.XMLUnescape("Godot Engine &lt;&amp;&gt;");  // "Godot Engine <&>"
    }

    private void BenchmarkIsValidFilename() {
        for (int i = 0; i < ITERATIONS; i++)
            StringExtensions.IsValidFileName("Godot Engine: Demo.exe");  // false
    }

    private void BenchmarkValidateNodeName() {
        for (int i = 0; i < ITERATIONS; i++)
            "TestNode:123456".ValidateNodeName();  // "TestNode123456"
    }


    private void BenchmarkCasecmpTo() {
        for (int i = 0; i < ITERATIONS; i++)
            "2 Example".CasecmpTo("10 Example");  // 1
    }


    private void BenchmarkNocasecmpTo() {
        for (int i = 0; i < ITERATIONS; i++)
            "2 Example".NocasecmpTo("10 Example");  // 1
    }


    private void BenchmarkToUtf8Buffer() {
        for (int i = 0; i < ITERATIONS; i++)
            "Godot Engine".ToUtf8Buffer();
    }


    private void BenchmarkToUtf16Buffer() {
        for (int i = 0; i < ITERATIONS; i++)
            "Godot Engine".ToUtf16Buffer();
    }


    private void BenchmarkToUtf32Buffer() {
        for (int i = 0; i < ITERATIONS; i++)
            "Godot Engine".ToUtf32Buffer();
    }
}
