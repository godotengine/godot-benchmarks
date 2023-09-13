#!/usr/bin/env bash
# Run all benchmarks on the server in various configurations.
#
# NOTE: This script is tailored for the dedicated benchmarking server.
#       It is not meant for local usage or experimentation.
#       `sudo` must be able to work non-interactively for the script to succeed.
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

restore_cpu_frequency() {
  echo "run-benchmarks: Restoring original CPU frequency scaling."
  # Restore original CPU frequency scaling, turbo mode and hypertheading.
  echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
  echo on | sudo tee /sys/devices/system/cpu/smt/control
  # Wait for CPU cores to be back online before changing the governor.
  sleep 1
  for core in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo powersave | sudo tee "$core"
  done
}

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

echo "run-benchmarks: Applying CPU frequency scaling optimized for stable benchmarking results."

# Use `performance` governor for a slight boost in building times.
for core in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
  echo performance | sudo tee "$core"
done

# Restore CPU frequency scaling if the script is canceled with Ctrl + C before it's done running.
# TODO: Run on errors as well.
trap restore_cpu_frequency SIGINT

GODOT_EMPTY_PROJECT_DIR="$DIR/web/godot-empty-project"

if [[ "$ARG1" != "--skip-build" ]]; then
  cd "$GODOT_REPO_DIR"

  git reset --hard
  git clean -qdfx --exclude bin
  git pull

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
  PEAK_MEMORY_BUILD_DEBUG=$(/usr/bin/time -f "%M" scons platform=linuxbsd target=editor optimize=debug progress=no -j$(nproc) 2>&1 | tail -1)
  END="$(date +%s%3N)"
  TIME_TO_BUILD_DEBUG="$((END - BEGIN))"

  git clean -qdfx --exclude bin
  if command -v ccache &> /dev/null; then
    # Clear ccache to avoid skewing the build time results.
    ccache --clear
  fi
  touch .gdignore

  BEGIN="$(date +%s%3N)"
  PEAK_MEMORY_BUILD_RELEASE=$(/usr/bin/time -f "%M" scons platform=linuxbsd target=template_release optimize=speed lto=full progress=no -j$(nproc) 2>&1 | tail -1)
  END="$(date +%s%3N)"
  TIME_TO_BUILD_RELEASE="$((END - BEGIN))"

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

# Strip debugging symbols for fair binary size comparison.
strip "$GODOT_DEBUG" "$GODOT_RELEASE"

BINARY_SIZE_DEBUG="$(stat --printf="%s" "$GODOT_DEBUG")"
BINARY_SIZE_RELEASE="$(stat --printf="%s" "$GODOT_RELEASE")"

COMMIT_HASH="$($GODOT_DEBUG --version | rev | cut --delimiter="." --field="1" | rev)"
DATE="$(date +'%Y-%m-%d')"

# Disable turbo mode and hyperthreading to reduce fluctuations in CPU performance.
echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
echo off | sudo tee /sys/devices/system/cpu/smt/control

# Measure average engine startup + shutdown times over 20 runs (in milliseconds),
# as well as peak memory usage.

# Perform a warmup run first.
echo "Performing debug warmup run."
$GODOT_DEBUG --audio-driver Dummy --path "$GODOT_EMPTY_PROJECT_DIR" --quit || true
TOTAL=0
for _ in {0..19}; do
	BEGIN="$(date +%s%3N)"
  echo "Performing benchmark debug startup/shutdown run."
	$GODOT_DEBUG --audio-driver Dummy --path "$GODOT_EMPTY_PROJECT_DIR" --quit || true
	END="$(date +%s%3N)"
	TOTAL="$((TOTAL + END - BEGIN))"
done
TIME_TO_STARTUP_SHUTDOWN_DEBUG="$((TOTAL / 20))"

# Run for 100 frames to ensure the metric is for the fully ready project.
echo "Performing benchmark debug peak memory usage run."
PEAK_MEMORY_STARTUP_SHUTDOWN_DEBUG=$(/usr/bin/time -f "%M" "$GODOT_DEBUG" --audio-driver Dummy --path "$GODOT_EMPTY_PROJECT_DIR" --quit-after 100 2>&1 | tail -1)

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

# Run for 100 frames to ensure the metric is for the fully ready project.
echo "Performing benchmark release peak memory usage run."
PEAK_MEMORY_STARTUP_SHUTDOWN_RELEASE=$(/usr/bin/time -f "%M" "$GODOT_RELEASE" --audio-driver Dummy --path "$GODOT_EMPTY_PROJECT_DIR" --quit-after 100 2>&1 | tail -1)

# Import resources in the project (required to run it).
echo "Performing resource importing."
$GODOT_DEBUG --editor --quit-after 100

# Run CPU benchmarks.

echo "Running CPU benchmarks."
pwd
$GODOT_DEBUG --audio-driver Dummy -- --run-benchmarks --exclude-benchmarks="rendering/*" --save-json="/tmp/cpu_debug.md" --json-results-prefix="cpu_debug"
$GODOT_RELEASE --audio-driver Dummy -- --run-benchmarks --exclude-benchmarks="rendering/*" --save-json="/tmp/cpu_release.md" --json-results-prefix="cpu_release"

# Run GPU benchmarks.
# TODO: Run on different GPUs.
$GODOT_RELEASE --audio-driver Dummy -- --run-benchmarks --include-benchmarks="rendering/*" --save-json="/tmp/amd.md" --json-results-prefix="amd"
$GODOT_RELEASE --audio-driver Dummy -- --run-benchmarks --include-benchmarks="rendering/*" --save-json="/tmp/intel.md" --json-results-prefix="intel"
$GODOT_RELEASE --audio-driver Dummy -- --run-benchmarks --include-benchmarks="rendering/*" --save-json="/tmp/nvidia.md" --json-results-prefix="nvidia"

rm -rf /tmp/godot-benchmarks-results/
# TODO: Change to godotengine organization URL.
# Clone a copy of the repository so we can push the new JSON files to it.
# The website build is performed by GitHub Actions on the `main` branch of the repository below,
# so we only push files to it and do nothing else.
git clone git@github.com:Calinou/godot-benchmarks-results.git /tmp/godot-benchmarks-results/

cd /tmp/godot-benchmarks-results/

# Merge benchmark run JSONs together.
# Use editor build as release build errors due to missing PCK file.
$GODOT_DEBUG --path "$DIR" --script merge_json.gd -- /tmp/cpu_debug.md /tmp/cpu_release.md /tmp/amd.md /tmp/intel.md /tmp/nvidia.md --output-path /tmp/merged.md

OUTPUT_PATH="/tmp/godot-benchmarks-results/${DATE}_${COMMIT_HASH}.md"
rm -f "$OUTPUT_PATH"

# Add extra JSON at the end of the merged JSON. We assume the merged JSON has no
# newline at the end of file, as Godot writes it. To append more data to the
# JSON dictionary, we remove the last `}` character and add a `,` instead.
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
git add .
git config --local user.name "Godot Benchmarks"
git config --local user.email "godot-benchmarks@example.com"
git commit --no-gpg-sign --message "Deploy benchmark results of $COMMIT_HASH (master at $DATE)

https://github.com/godotengine/godot/commit/$COMMIT_HASH"
git push

cd "$DIR"

restore_cpu_frequency
