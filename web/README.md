# Web interface for benchmark results

This website is built with the [Hugo](https://gohugo.io/) static site generator.
It's designed to work **exclusively** with the [`run-benchmarks.sh` script](../run-benchmarks.sh),
which runs benchmarks on a dedicated server with various GPU models.

## How it works

- Using the [`run-benchmarks.sh` script](../run-benchmarks.sh), benchmark data
  is collected and saved to a single JSON file for each engine commit, with 5 runs:
  - CPU (debug template)
  - CPU (release template)
  - GPU (AMD, release template)
<!--
  - GPU (Intel, release template)
  - GPU (NVIDIA, release template)
-->
- [Hugo](https://gohugo.io/) is used to create a homepage listing recent
  benchmarked commits, plus a single page per engine commit. This allows linking
  to individual benchmarked commit in a future-proof way.
- [ApexCharts](https://apexcharts.com/) is used to draw graphs on the homepage.
- [Water.css](https://watercss.kognise.dev/) is used to provide styling,
  including automatic dark theme support.

### Building

## Development

- Create JSON data or fetch existing JSON data from the live website.
- Save this JSON data to the `content` folder with the following naming convention:
  `YYYY-MM-DD_hash.json` where `hash` is a 9-character Git commit hash of the
  Godot build used (truncated from a full commit hash).
- Run `hugo server`.

## Production

- Follow the same steps as in the **Development** section above.
- Run `hugo --minify`.
