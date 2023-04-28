#!/bin/bash -e

GODOT_BIN=${GODOT_BIN:-~/Downloads/Godot_v4.0.2-stable_linux.x86_64}
#TRACE_COMMAND=

if ! $GODOT_BIN --version; then
	echo
	echo "	[TRACE_COMMAND=renderdoc/gfxr/fossilize.sh]    GODOT_BIN=/path/to/godot4/binary    $0"
	echo
	exit
fi

if [[ ! -d .godot ]]; then
	echo "Initializing first run... (this will take a few seconds)"
	timeout 5 $GODOT_BIN -e --headless >/dev/null 2>/dev/null || true
fi

$TRACE_COMMAND $GODOT_BIN --disable-vsync --fixed-fps 10 -- --run-benchmarks --run-while='frame<10' --include-benchmarks="rendering/*"

exit



#Trace each benchmark to its own file, disabled for now

$GODOT_BIN --headless -- --run-benchmarks --run-while=false --include-benchmarks='rendering/*' | grep ^Running | sed -e 's/.* //' >/tmp/benchmarks.txt
cat /tmp/benchmarks.txt | while read benchmark_name; do
	$TRACE_COMMAND $GODOT_BIN --disable-vsync --fixed-fps 10 -- --run-benchmarks --run-while='frame<10' --include-benchmarks="$benchmark_name"
done
