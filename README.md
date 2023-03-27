# godot-benchmarks

This is a Godot project that stores and runs a collection of benchmarks. It is
used to test performance of different areas of [Godot](https://godotengine.org)
such as rendering and scripting.

**Interested in adding new benchmarks?** See [CONTRIBUTING.md](CONTRIBUTING.md).

## Running benchmarks

### Using a graphical interface

Open the project in the editor, then run it from the editor or from an export
template binary. Select benchmarks you want to run, then click the **Run** button
in the bottom-right corner.

Once benchmarks are run, you can copy the results JSON using the
**Copy JSON to Clipboard** button at the bottom. The results JSON is also printed to
standard output, which you can see if you're running the project from a terminal.

### Using the command line

After opening the project in the editor (required so that resources can be imported),
you can run benchmarks from an editor or export template binary. The project will
automatically quit after running benchmarks.

The results JSON is printed to standard output once all benchmarks are run.
You can save the results JSON to a file using `--save-json="path/to/file.json"`
(the target folder **must** exist).

> **Note**
>
> To import the project in the editor from the command line, use `godot --editor --quit`.
> If this doesn't work, use `timeout 30 godot --editor`.

> **Note**
>
> `godot` is assumed to be in your `PATH` environment variable here. If this is
> not the case, replace `godot` with the absolute path to your Godot editor or export template
> binary.

#### Run all benchmarks

```bash
# The first `--` is important.
# Otherwise, Godot won't pass the CLI arguments to the project.
godot -- --run-benchmarks
```

#### Run a single benchmark

The `--include-benchmarks` CLI argument can be used to specify the name.
The project will print a message to acknowledge that your argument was taken
into account for filtering benchmarks.

Benchmark names all follow `category/subcategory/some_name` naming, with
`category/subcategory` being the name *all* path components (folders) and
`some_name` being the name of the benchmark's scene file without the `.tscn` extension.

```bash
godot -- --run-benchmarks --include-benchmarks="rendering/culling/basic_cull"
```

#### Run a category of benchmarks

Use glob syntax (with `*` acting as a wildcard) to run a category of benchmarks:

```bash
--include-benchmarks="rendering/culling/basic_cull"
```

You can exclude specific benchmarks using the `--exclude-benchmarks` command line argument.
This argument also supports globbing and can be used at the same time as `--include-benchmarks`.

## Tips and tricks

### Comparing results between runs

[`jq`](https://github.com/stedolan/jq) is a command line tool that greatly simplifies
the task of processing JSON files. You can use the following command as a starting point
for creating benchmark comparisons:

```bash
jq -n --tab '
	[inputs.benchmarks] | transpose[] | select(all(.results != {})) |
	.[0].results = (
		[[.[].results | to_entries] | transpose[] | select(all(.value != 0)) |
		{key: .[0].key, value: {
			a: .[0].value,
			b: .[1].value,
			a_div_b: (.[0].value / .[1].value)
		}}] | from_entries
	) | .[0]
' a.json b.json
```

Sample output (truncated to a single benchmark for brevity):

```json
{
	"category": "Rendering > Lights And Meshes",
	"name": "Sphere 1000",
	"results": {
		"render_cpu": {
			"a": 3.952,
			"b": 4.031,
			"a_div_b": 0.9804018853882412
		},
		"render_gpu": {
			"a": 45.36,
			"b": 45.44,
			"a_div_b": 0.9982394366197184
		},
		"time": {
			"a": 38.95,
			"b": 35.04,
			"a_div_b": 1.1115867579908676
		}
	}
}
```
