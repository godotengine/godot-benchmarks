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

# Make the command line argument optional without tripping up `set -u`.
ARG1="${1:-''}"

if [[ "$ARG1" == "--help" || "$ARG1" == "-h" ]]; then
  echo "Usage: $0 [--skip-build]"
  exit
fi

if [[ ! -d "godot" ]]; then
  git clone https://github.com/godotengine/godot.git
fi

GODOT_REPO_DIR="$DIR/godot"

# Use `performance` governor, disable turbo mode and hyperthreading to reduce fluctuations in CPU performance.
for core in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
  echo performance | sudo tee "$core"
done
echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
echo off | sudo tee /sys/devices/system/cpu/smt/control

if [[ "$ARG1" != "--skip-build" ]]; then
  pushd "$GODOT_REPO_DIR"

  # Measure clean build times for debug and release builds (in milliseconds).
  # Also create a `.gdignore` file to prevent Godot from importing resources
  # within the Godot Git clone.
  # WARNING: Any untracked and ignored files included in the repository will be removed!
  BEGIN="$(date +%s%3N)"
  git clean -qdfx --exclude bin
  if command -v ccache &> /dev/null; then
    # Clear ccache to avoid skewing the build time results.
    ccache --clear
  fi
  touch .gdignore
  scons platform=linuxbsd target=template_debug progress=no -j$(nproc)
  END="$(date +%s%3N)"
  TIME_TO_BUILD_DEBUG="$((END - BEGIN))"

  BEGIN="$(date +%s%3N)"
  git clean -qdfx --exclude bin
  if command -v ccache &> /dev/null; then
    # Clear ccache to avoid skewing the build time results.
    ccache --clear
  fi
  touch .gdignore
  scons platform=linuxbsd target=template_release optimize=speed use_lto=yes progress=no -j$(nproc)
  END="$(date +%s%3N)"
  TIME_TO_BUILD_RELEASE="$((END - BEGIN))"

  popd
else
  echo "run-benchmarks: Skipping engine build as requested on the command line."
fi

# Path to the Godot debug binary to run. Used for CPU debug benchmarks.
GODOT_DEBUG="$GODOT_REPO_DIR/bin/godot.linuxbsd.template_debug.x86_64"

# Path to the Godot release binary to run. Used for CPU release and GPU benchmarks.
# The release binary is assumed to be the same commit as the debug build.
# Things will break if this is not the case.
GODOT_RELEASE="$GODOT_REPO_DIR/bin/godot.linuxbsd.template_release.x86_64"

# Strip debugging symbols for fair binary size comparison.
strip "$GODOT_DEBUG" "$GODOT_RELEASE"

COMMIT_HASH="$($GODOT_DEBUG --version | rev | cut --delimiter="." --field="1" | rev)"
DATE="$(date +'%Y-%m-%d')"
OUTPUT_PATH="web/content/${DATE}_${COMMIT_HASH}.md"

# TODO: Concatenate JSONs into a single JSON file as follows:
# {
#  "cpu_debug": {...},
#  "cpu_release": {...},
#  "gpu_amd": {...},
#  "gpu_intel": {...},
#  "gpu_nvidia": {...},
#  "build_times": {"debug": 12345, "release": 12345},
#  "startup_shutdown_times": {"debug": 12345, "release": 12345}
# }
# Figure out if only the `benchmarks` section can be added to each type, with
# `engine` and `system` being top-level to reduce data duplication (and with all GPUs listed).

# Measure average engine startup + shutdown times over 20 runs (in milliseconds).
# Perform a warmup run first.
$GODOT_DEBUG --quit || true
TOTAL=0
for _ in {0..19}; do
	BEGIN="$(date +%s%3N)"
	$GODOT_DEBUG --quit || true
	END="$(date +%s%3N)"
	TOTAL="$((TOTAL + END - BEGIN))"
done
TIME_TO_STARTUP_SHUTDOWN_DEBUG="$((TOTAL / 20))"

# Perform a warmup run first.
$GODOT_RELEASE --quit || true
TOTAL=0
for _ in {0..19}; do
	BEGIN="$(date +%s%3N)"
	$GODOT_RELEASE --quit || true
	END="$(date +%s%3N)"
	TOTAL="$((TOTAL + END - BEGIN))"
done
TIME_TO_STARTUP_SHUTDOWN_RELEASE="$((TOTAL / 20))"

# Run CPU benchmarks.
$GODOT_DEBUG -- --run-benchmarks --exclude-benchmarks="rendering/*" --save-json="/tmp/cpu_debug.md"
$GODOT_RELEASE -- --run-benchmarks --exclude-benchmarks="rendering/*" --save-json="/tmp/cpu_release.md"

# Run GPU benchmarks.
$GODOT_RELEASE -- --run-benchmarks --include-benchmarks="rendering/*" --save-json="/tmp/gpu_amd.md"
# TODO: Uncomment for production use.
#$GODOT_RELEASE -- --run-benchmarks --include-benchmarks="rendering/*" --save-json="/tmp/gpu_intel.md"
#$GODOT_RELEASE -- --run-benchmarks --include-benchmarks="rendering/*" --save-json="/tmp/gpu_nvidia.md"

mkdir -p "$(dirname "$OUTPUT_PATH")"
cat > "$OUTPUT_PATH" << EOF
{
  "cpu_debug": $(cat /tmp/cpu_debug.md),
  "cpu_release": $(cat /tmp/cpu_release.md),
  "gpu_amd": $(cat /tmp/gpu_amd.md),
  "gpu_intel": $(cat /tmp/gpu_intel.md),
  "gpu_nvidia": $(cat /tmp/gpu_nvidia.md),
  "build_times": {
    "debug": $TIME_TO_BUILD_DEBUG,
    "release": $TIME_TO_BUILD_RELEASE
  },
  "startup_shutdown_times": {
    "debug": $TIME_TO_STARTUP_SHUTDOWN_DEBUG,
    "release": $TIME_TO_STARTUP_SHUTDOWN_RELEASE
  }
}
EOF

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

# Restore original CPU frequency scaling, turbo mode and hypertheading.
for core in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
  echo powersave | sudo tee "$core"
done
echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
echo on | sudo tee /sys/devices/system/cpu/smt/control
