#!/usr/bin/env bash
# Run all benchmarks on the server in various configurations.
#
# NOTE: This script is tailored for the dedicated benchmarking server.
#       It is not meant for local usage or experimentation.
set -euo pipefail
IFS=$'\n\t'

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! "${1:-}" || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  echo "Usage: $(basename "$0") <path to full, non-shallow Godot Git clone directory>"

  # Exit with code 0 only if help was explicitly requested.
  if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    exit 0
  else
    exit 1
  fi
fi

GODOT_REPO_DIR="$1"

pushd "$GODOT_REPO_DIR"

BEGIN="$(date +%s)"
scons platform=linuxbsd target=template_debug -j$(nproc)
END="$(date +%s)"
TIME_TO_BUILD_DEBUG="$((END - BEGIN))"

BEGIN="$(date +%s)"
scons platform=linuxbsd target=template_release optimize=speed use_lto=yes -j$(nproc)
END="$(date +%s)"
TIME_TO_BUILD_RELEASE="$((END - BEGIN))"

popd

# Path to the Godot debug binary to run. Used for CPU debug benchmarks.
GODOT_DEBUG="$GODOT_REPO_DIR/bin/godot.linuxbsd.template_debug.x86_64"

# Path to the Godot release binary to run. Used for CPU release and GPU benchmarks.
# The release binary is assumed to be the same commit as the debug build.
# Things will break if this is not the case.
GODOT_DEBUG="$GODOT_REPO_DIR/bin/godot.linuxbsd.template_release.x86_64"

COMMIT_HASH="$($GODOT_DEBUG --version | rev | cut --delimiter="." --field="1" | rev)"
DATE="$(date +'%Y-%m-%d')"
OUTPUT_DIR="web/content/${DATE}_${COMMIT_HASH}"
mkdir -p "$OUTPUT_DIR"
# Required for the Hugo page bundle to show up.
touch "$OUTPUT_DIR/index.md"

# TODO: Concatenate JSONs into a single JSON file as follows:
# {
#  "cpu_debug": {...},
#  "cpu_release": {...},
#  "gpu_amd": {...},
#  "gpu_intel": {...},
#  "gpu_nvidia": {...},
#  "build_times": {"debug": 12345, "release": 12345},
# }
# Figure out if only the `benchmarks` section can be added to each type, with
# `engine` and `system` being top-level to reduce data duplication (and with all GPUs listed).

# Run CPU benchmarks.
$GODOT_DEBUG -- --run-benchmarks --exclude-benchmarks="rendering/*" --save-json="$OUTPUT_DIR/cpu_debug.md"
$GODOT_RELEASE -- --run-benchmarks --exclude-benchmarks="rendering/*" --save-json="$OUTPUT_DIR/cpu_release.md"

# Run GPU benchmarks.
$GODOT_RELEASE -- --run-benchmarks --include-benchmarks="rendering/*" --save-json="$OUTPUT_DIR/gpu_amd.md"
# TODO: Uncomment for production use.
#$GODOT_RELEASE -- --run-benchmarks --include-benchmarks="rendering/*" --save-json="$OUTPUT_DIR/gpu_intel.md"
#$GODOT_RELEASE -- --run-benchmarks --include-benchmarks="rendering/*" --save-json="$OUTPUT_DIR/gpu_nvidia.md"

rm -rf /tmp/godot-benchmarks-results/
# TODO: Change to godotengine organization URL.
git clone --depth=1 git@github.com:Calinou/godot-benchmarks-results.git /tmp/godot-benchmarks-results/

pushd /tmp/godot-benchmarks-results/

# Build website files in `web/` after running all benchmarks, so that benchmarks
# appear on the web interface.
hugo --source="$DIR/web/" --destination=/tmp/godot-benchmarks-results/ --minify
git add .
git commit --amend --no-edit
git push -f

popd
