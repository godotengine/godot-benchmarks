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
import os
from os.path import isdir, isfile, join

# Source data paths.
graphs_path = "./src-data/graphs.json"
if len(sys.argv) == 1:
    benchmarks_path = "./src-data/benchmarks"
elif len(sys.argv) == 2:
    benchmarks_path = sys.argv[1]
    if not isdir(benchmarks_path):
        raise ValueError(benchmarks_path + " is not a valid folder")
else:
    raise ValueError("Invalid number of arguments")


# Bnase data.json dictionary.
data_output_json = {
    "benchmarks": [],
    "graphs": [],
}

### BENCHMARKS ###

# Fetch the list of benchmark files
benchmark_input_filename_test = lambda f: (f.endswith(".json") or f.endswith(".md"))
benchmarks_files = [
    f for f in os.listdir(benchmarks_path) if (isfile(join(benchmarks_path, f)) and benchmark_input_filename_test(f))
]

# Add the list of benchmarks.
for f in benchmarks_files:
    json_file = open(join(benchmarks_path, f))

    # Extract data from filename.
    key = f.removesuffix(".json").removesuffix(".md")
    date = key.split("_")[0]
    commit = key.split("_")[1]

    # Load and modify the benchmark file.
    output_dict = json.load(json_file)
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
    json_file.close()

### GRAPHS ###

# Add the graphs.
json_file = open(graphs_path)
data_output_json["graphs"] = json.load(json_file)
json_file.close()

### DUMPING data.json ###

# Create a big json with all of the data.
data_filename = "./data/data.json"
data_file = open(data_filename, "w")
json.dump(data_output_json, data_file, indent=4)
data_file.close()

### CREATE .md FILES (for the pages) ###

# Create a .md file for each benchmark.
benchmarks_content_path = "./content/benchmark"
if not os.path.exists(benchmarks_content_path):
    os.mkdir(benchmarks_content_path)
for benchmark in data_output_json["benchmarks"]:
    filename = benchmark["date"] + "_" + benchmark["commit"] + ".md"
    open(join(benchmarks_content_path, filename), "a").close()

# Create a .md file for each graph.
graphs_content_path = "./content/graph"
if not os.path.exists(graphs_content_path):
    os.mkdir(graphs_content_path)
for graph in data_output_json["graphs"]:
    filename = graph["id"] + ".md"
    open(join(graphs_content_path, filename), "a").close()
