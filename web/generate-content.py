#!/usr/bin/env python3
#
# Usage:
# generate-content.py [benchmarks-folder]
#
# This script generates the content and data files for hugo.
# This should be ran before trying to build the site.
#
# It takes as input two files, a "graph.json" in the ./src-data folder,
# and the results of our godot benchmarks (produced by ../run-benchmarks.sh)
# By default, benchmarks (.json or .md, but all should be JSON inside ¯\_(ツ)_/¯)
# are taken from the "./src-data/benchmarks". But you can specify an optional
# folder otherwise as argument.

import json
import sys
import pathlib

# Source data paths.
if len(sys.argv) == 1:
    benchmarks_path = "./src-data/benchmarks"
elif len(sys.argv) == 2:
    benchmarks_path = sys.argv[1]
    if not pathlib.Path(benchmarks_path).is_dir():
        raise ValueError(benchmarks_path + " is not a valid folder")
else:
    raise ValueError("Invalid number of arguments")


# Bnase data.json dictionary.
data_output_json = {
    "benchmarks": [],
    "graphs": [],
}

### BENCHMARKS ###

# Add the list of benchmarks.
for path in pathlib.Path(benchmarks_path).glob("*"): # type: pathlib.Path
    if path.suffix != ".md" and path.suffix != ".json":
        continue

    parts = path.stem.split("_")
    if len(parts) != 2: # Could be the readme, for example
        continue

    date, commit = parts

    # Load and modify the benchmark file.
    output_dict = json.loads(path.read_text())
    output_dict["date"] = date
    output_dict["commit"] = commit

    # Merge category and name into a single "path" field.
    output_benchmark_list = []
    for benchmark in output_dict["benchmarks"]:
        output_benchmark_list.append(
            {
                "path": [el.strip() for el in benchmark["category"].split(">")] + [benchmark["name"]],
                "results": benchmark["results"],
            }
        )
    output_dict["benchmarks"] = output_benchmark_list

    # Add it to the list.
    data_output_json["benchmarks"].append(output_dict)

### GRAPHS ###

# Add the graphs.
data_output_json["graphs"] = json.loads(pathlib.Path("src-data/graphs.json").read_text())

### DUMPING data.json ###

# Create a big json with all of the data.
pathlib.Path("data/data.json").write_text(json.dumps(data_output_json, indent=4))

### CREATE .md FILES (for the pages) ###

# Create a .md file for each benchmark.
benchmarks_content_path = pathlib.Path("./content/benchmark")
benchmarks_content_path.mkdir(exist_ok=True)
for benchmark in data_output_json["benchmarks"]:
    filename = benchmark["date"] + "_" + benchmark["commit"] + ".md"
    (benchmarks_content_path / filename).touch(exist_ok=True)

# Create a .md file for each graph.
graphs_content_path = pathlib.Path("./content/graph")
graphs_content_path.mkdir(exist_ok=True)
for graph in data_output_json["graphs"]:
    filename = graph["id"] + ".md"
    (graphs_content_path / filename).touch(exist_ok=True)
