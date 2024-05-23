#!/usr/bin/env bash
# Run all benchmarks on the server in various configurations.
#
# NOTE: This script is tailored for the dedicated benchmarking server.
#       It is not meant for local usage or experimentation.
set -euo pipefail
IFS=$'\n\t'

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Reduce log spam and avoid issues with self-compiled builds crashing:
# https://github.com/godotengine/godot/issues/75409
export MANGOHUD=0

# Set X11 display for headless usage (with a X server running separately).
export DISPLAY=":0"

# Make the command line argument optional without tripping up `set -u`.
ARG1="${1:-''}"

if ! command -v git &> /dev/null; then
  echo "ERROR: git must be installed and in PATH."
  exit 1
fi

if [[ "$ARG1" == "--help" || "$ARG1" == "-h" ]]; then
  echo "Usage: $0 [--skip-build]"
  exit
fi

GODOT_REPO_DIR="$DIR/godot"

if [[ ! -d "$GODOT_REPO_DIR/.git" ]]; then
  git clone https://github.com/godotengine/godot.git "$GODOT_REPO_DIR"
fi

pushd "$GODOT_REPO_DIR"
git reset --hard
git clean -qdfx --exclude bin
git pull
popd

# Check if latest commit is already benchmarked in the results repository. If so, skip running the benchmark.
rm -rf /tmp/godot-benchmarks-results/
git clone git@github.com:godotengine/godot-benchmarks-results.git /tmp/godot-benchmarks-results/
latest_commit="$(git -C "$GODOT_REPO_DIR" rev-parse HEAD)"

pushd /tmp/godot-benchmarks-results/
for result in 2*.md; do
  if [[ "${result:11:9}" == "${latest_commit:0:9}" ]]; then
    echo "godot-benchmarks: Skipping benchmark run as the latest Godot commit is already present in the results repository."
    exit
  fi
done
popd

GODOT_EMPTY_PROJECT_DIR="$DIR/web/godot-empty-project"

if [[ "$ARG1" != "--skip-build" ]]; then
  cd "$GODOT_REPO_DIR"

  if command -v ccache &> /dev/null; then
    # Clear ccache to avoid skewing the build time results.
    ccache --clear
  fi
  touch .gdignore

  # Measure clean build times for debug and release builds (in milliseconds).
  # Also create a `.gdignore` file to prevent Godot from importing resources
  # within the Godot Git clone.
  # WARNING: Any untracked and ignored files included in the repository will be removed!
  BEGIN="$(date +%s%3N)"
  PEAK_MEMORY_BUILD_DEBUG=$( (/usr/bin/time -f "%M" scons platform=linuxbsd target=editor optimize=debug module_mono_enabled=no progress=no debug_symbols=yes -j$(nproc) 2>&1 || true) | tail -1)
  END="$(date +%s%3N)"
  TIME_TO_BUILD_DEBUG="$((END - BEGIN))"

  git clean -qdfx --exclude bin
  if command -v ccache &> /dev/null; then
    # Clear ccache to avoid skewing the build time results.
    ccache --clear
  fi
  touch .gdignore

  BEGIN="$(date +%s%3N)"
  PEAK_MEMORY_BUILD_RELEASE=$( (/usr/bin/time -f "%M" scons platform=linuxbsd target=template_release optimize=speed lto=full module_mono_enabled=no progress=no debug_symbols=yes -j$(nproc) 2>&1 || true) | tail -1)
  END="$(date +%s%3N)"
  TIME_TO_BUILD_RELEASE="$((END - BEGIN))"

  # FIXME: C# is disabled because the engine crashes on exit after running benchmarks.
  #
  # Generate Mono glue for C# build to work.
  # echo "Generating .NET glue."
  # bin/godot.linuxbsd.editor.x86_64.mono --headless --generate-mono-glue modules/mono/glue
  # echo "Building .NET assemblies."
  # # https://docs.godotengine.org/en/stable/contributing/development/compiling/compiling_with_dotnet.html#nuget-packages
  # mkdir -p "$HOME/MyLocalNugetSource"
  # # Source may already exist, so allow failure for the command below.
  # dotnet nuget add source "$HOME/MyLocalNugetSource" --name MyLocalNugetSource || true
  # modules/mono/build_scripts/build_assemblies.py --godot-output-dir=./bin --push-nupkgs-local "$HOME/MyLocalNugetSource"

  cd "$DIR"
else
  echo "run-benchmarks: Skipping engine build as requested on the command line."
  TIME_TO_BUILD_DEBUG=1
  TIME_TO_BUILD_RELEASE=1
  PEAK_MEMORY_BUILD_DEBUG=1
  PEAK_MEMORY_BUILD_RELEASE=1
fi

# Path to the Godot debug binary to run. Used for CPU debug benchmarks.
GODOT_DEBUG="$GODOT_REPO_DIR/bin/godot.linuxbsd.editor.x86_64"

# Path to the Godot release binary to run. Used for CPU release and GPU benchmarks.
# The release binary is assumed to be the same commit as the debug build.
# Things will break if this is not the case.
GODOT_RELEASE="$GODOT_REPO_DIR/bin/godot.linuxbsd.template_release.x86_64"

COMMIT_HASH="$($GODOT_DEBUG --version | rev | cut --delimiter="." --field="1" | rev)"
DATE="$(date +'%Y-%m-%d')"

# Measure average engine startup + shutdown times over 20 runs (in milliseconds),
# as well as peak memory usage.

# Perform a warmup run first.
echo "Performing debug warmup run."
$GODOT_DEBUG --audio-driver Dummy --gpu-index 1 --path "$GODOT_EMPTY_PROJECT_DIR" --quit || true
TOTAL=0
for _ in {0..19}; do
	BEGIN="$(date +%s%3N)"
  echo "Performing benchmark debug startup/shutdown run."
	$GODOT_DEBUG --audio-driver Dummy --gpu-index 1 --path "$GODOT_EMPTY_PROJECT_DIR" --quit || true
	END="$(date +%s%3N)"
	TOTAL="$((TOTAL + END - BEGIN))"
done
TIME_TO_STARTUP_SHUTDOWN_DEBUG="$((TOTAL / 20))"

echo "Performing benchmark debug peak memory usage run."
PEAK_MEMORY_STARTUP_SHUTDOWN_DEBUG=$(/usr/bin/time -f "%M" "$GODOT_DEBUG" --audio-driver Dummy --gpu-index 1 --path "$GODOT_EMPTY_PROJECT_DIR" --quit 2>&1 | tail -1)

# Perform a warmup run first.
echo "Performing release warmup run."
$GODOT_RELEASE --audio-driver Dummy --path "$GODOT_EMPTY_PROJECT_DIR" --quit || true
TOTAL=0
for _ in {0..19}; do
	BEGIN="$(date +%s%3N)"
  echo "Performing benchmark release startup/shutdown run."
	$GODOT_RELEASE --audio-driver Dummy --path "$GODOT_EMPTY_PROJECT_DIR" --quit || true
	END="$(date +%s%3N)"
	TOTAL="$((TOTAL + END - BEGIN))"
done
TIME_TO_STARTUP_SHUTDOWN_RELEASE="$((TOTAL / 20))"

echo "Performing benchmark release peak memory usage run."
PEAK_MEMORY_STARTUP_SHUTDOWN_RELEASE=$(/usr/bin/time -f "%M" "$GODOT_RELEASE" --audio-driver Dummy --gpu-index 1 --path "$GODOT_EMPTY_PROJECT_DIR" --quit 2>&1 | tail -1)

# Import resources and build C# solutions in the project (required to run it).
echo "Performing resource importing and C# solution building."
$GODOT_DEBUG --headless --editor --gpu-index 1 --build-solutions --quit-after 2

# Run CPU benchmarks.

echo "Running CPU benchmarks."
$GODOT_DEBUG --audio-driver Dummy --gpu-index 1 -- --run-benchmarks --exclude-benchmarks="rendering/*" --save-json="/tmp/cpu_debug.md" --json-results-prefix="cpu_debug"
$GODOT_RELEASE --audio-driver Dummy --gpu-index 1 -- --run-benchmarks --exclude-benchmarks="rendering/*" --save-json="/tmp/cpu_release.md" --json-results-prefix="cpu_release"

# Run GPU benchmarks.
# TODO: Run on NVIDIA GPU.
echo "Running GPU benchmarks."
$GODOT_RELEASE --audio-driver Dummy --gpu-index 1 -- --run-benchmarks --include-benchmarks="rendering/*" --save-json="/tmp/amd.md" --json-results-prefix="amd"
$GODOT_RELEASE --audio-driver Dummy --gpu-index 0 -- --run-benchmarks --include-benchmarks="rendering/*" --save-json="/tmp/intel.md" --json-results-prefix="intel"
#$GODOT_RELEASE --audio-driver Dummy --gpu-index 2 -- --run-benchmarks --include-benchmarks="rendering/*" --save-json="/tmp/nvidia.md" --json-results-prefix="nvidia"

# We cloned a copy of the repository above so we can push the new JSON files to it.
# The website build is performed by GitHub Actions on the `main` branch of the repository below,
# so we only push files to it and do nothing else.
cd /tmp/godot-benchmarks-results/

# Merge benchmark run JSONs together.
# Use editor build as release build errors due to missing PCK file.
echo "Merging JSON files together."
$GODOT_DEBUG --headless --path "$DIR" --script merge_json.gd -- /tmp/cpu_debug.md /tmp/cpu_release.md /tmp/amd.md /tmp/intel.md --output-path /tmp/merged.md
#$GODOT_DEBUG --headless --path "$DIR" --script merge_json.gd -- /tmp/cpu_debug.md /tmp/cpu_release.md /tmp/amd.md /tmp/intel.md /tmp/nvidia.md --output-path /tmp/merged.md

OUTPUT_PATH="/tmp/godot-benchmarks-results/${DATE}_${COMMIT_HASH}.md"
rm -f "$OUTPUT_PATH"

# Strip debugging symbols for fair binary size comparison.
# Do this after Godot is run so we can have useful crash backtraces
# if the engine crashes while running benchmarks.
strip "$GODOT_DEBUG" "$GODOT_RELEASE"

BINARY_SIZE_DEBUG="$(stat --printf="%s" "$GODOT_DEBUG")"
BINARY_SIZE_RELEASE="$(stat --printf="%s" "$GODOT_RELEASE")"

# Add extra JSON at the end of the merged JSON. We assume the merged JSON has no
# newline at the end of file, as Godot writes it. To append more data to the
# JSON dictionary, we remove the last `}` character and add a `,` instead.
echo "Appending extra JSON at the end of the merged JSON."
EXTRA_JSON=$(cat << EOF
"binary_size": {
  "debug": $BINARY_SIZE_DEBUG,
  "release": $BINARY_SIZE_RELEASE
},
"build_time": {
  "debug": $TIME_TO_BUILD_DEBUG,
  "release": $TIME_TO_BUILD_RELEASE
},
"build_peak_memory_usage": {
  "debug": $PEAK_MEMORY_BUILD_DEBUG,
  "release": $PEAK_MEMORY_BUILD_RELEASE
},
"empty_project_startup_shutdown_time": {
  "debug": $TIME_TO_STARTUP_SHUTDOWN_DEBUG,
  "release": $TIME_TO_STARTUP_SHUTDOWN_RELEASE
},
"empty_project_startup_shutdown_peak_memory_usage": {
  "debug": $PEAK_MEMORY_STARTUP_SHUTDOWN_DEBUG,
  "release": $PEAK_MEMORY_STARTUP_SHUTDOWN_RELEASE
}
EOF
)
echo "$(head -c -1 /tmp/merged.md),$EXTRA_JSON}" > "$OUTPUT_PATH"

# Build website files after running all benchmarks, so that benchmarks
# appear on the web interface.
echo "Pushing results to godot-benchmarks repository."
git add .
git config --local user.name "Godot Benchmarks"
git config --local user.email "godot-benchmarks@example.com"
git commit --no-gpg-sign --message "Deploy benchmark results of $COMMIT_HASH (master at $DATE)

https://github.com/godotengine/godot/commit/$COMMIT_HASH"
git push

cd "$DIR"
echo "Success."
