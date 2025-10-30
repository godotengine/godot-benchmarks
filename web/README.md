# Web interface for benchmark results

This website is built with the [Hugo](https://gohugo.io/) static site generator.
It's designed to work **exclusively** with the [`run-benchmarks.sh` script](../run-benchmarks.sh),
which runs benchmarks on a dedicated server with various GPU models.

## How it works

- Using the [`run-benchmarks.sh` script](../run-benchmarks.sh), benchmark data
  is collected and saved to a single JSON file for each engine commit, with 4 runs:
  - CPU (debug template)
  - CPU (release template)
  - GPU (AMD, release template)
  - GPU (Intel, release template)
  - GPU (NVIDIA, release template)
- The produced results (as .json or .md) should be copied into the `src-data/benchmarks` folder.
- The [./generate-content.py script](./generate-content.py) produces `.md` files
  in the `content` folder, so that web pages can be generated for each graph and each benchmark.
- [Hugo](https://gohugo.io/) is used to create a homepage listing recent
  benchmarked commits, plus a single page per engine commit. This allows linking
  to individual benchmarked commit in a future-proof way.
- [Plotly.js](https://plotly.com/javascript/) is used to draw graphs on the homepage.
- [Water.css](https://watercss.kognise.dev/) is used to provide styling,
  including automatic dark theme support.

## Building

### Development

Create JSON data (using the `run-benchmarks.sh` script, as described above),
or fetch existing JSON data from the live website:

```shell
git clone https://github.com/godotengine/godot-benchmarks-results.git src-data/benchmarks
```

Generate server files from the benchmarks:

```shell
python content.py
```

Now, you can run the server:

```shell
hugo server
```

### Production

- Follow the same steps as in the **Development** section above.
- Run `hugo --minify`.
