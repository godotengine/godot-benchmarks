# Contributing to godot-benchmarks

Thank you for your interest in contributing!

**Note:** This project only supports Godot's `master` branch (4.0's development
branch), not Godot 3.x. Attempting to open this project in Godot 3.x will result
in errors.

## Adding new benchmarks

You can add new test cases by following these steps:

### Create new benchmark

- Open the Godot editor and import this project.
- Create a new scene with `snake_case` naming with a root node suited to the
  benchmark[^1], then save it in one of the existing folders depending on its
  category. If your benchmark does not suit any existing category or
  subcategory, you can also create a new folder in the repository's root folder.
  The root node's name does not have any bearing on functionality, but it's
  recommended to use a PascalCase version of the scene name. For example, if
  your scene file name is `typed_int_array.tscn`, the root node name should be
  `TypedIntArray`.

[^1]: For 3D rendering benchmarks, the root node should be Node3D. For 2D
rendering benchmarks, the root node should be Node2D. For UI benchmarks, the
root node should be Control. For scripting or miscellaneous benchmarks, the root
node should be Node.

### Configure the benchmark

- Create a Label node, rename it to `Benchmark` (case-sensitive) and attach
  `benchmark.gd` as a script. Select the Benchmark node to configure its
  properties. There are 5 properties available which control the *metrics* that
  will be displayed in the results table:
  - **Test Render Cpu:** Enable this for rendering benchmarks. Leave it disabled
    for other benchmarks.
  - **Test Render Gpu:** Enable this for rendering benchmarks. Leave it disabled
    for other benchmarks.
  - **Test Idle:** Enable this for non-rendering CPU-intensive benchmarks. Leave
    it disabled for other benchmarks.
  - **Test Physics:** Enable this for physics benchmarks. Leave it disabled for
    other benchmarks.
  - **Time Limit:** Enable this for rendering or physics benchmarks (which
    measure the time spent processing things every frame instead of a total time
    to process a set amount of items). For other benchmarks such as scripting,
    disable this.
- Attach a script to the scene's root node, with the same name as the scene file
  (except the file extension will be `.gd` instead of `.tscn`). In the script's
  `_ready()` function, perform the benchmark tasks. You don't need to surround
  the benchmarked code with time measurement functions, as time is measured
  automatically.
- For benchmarks that do not have a fixed time limit (such as scripting benchmarks),
  call `Manager.end_test()` at the end of the `_ready()` function.
- Modify `manager.gd` in the repository root to include your new benchmark
  (`tests` array variable). The new benchmark should be listed at the bottom of
  the category it was added to. For clarity, make sure to separate each category
  with a blank line within the `tests` array.

Remember to follow the
[GDScript style guide](https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript_styleguide.html)
when writing new scripts. Adding type hints is recommended whenever possible,
unless you are specifically benchmarking non-typed scripts.

### Test the benchmark

- Run the project in the editor.
- Check the checkbox next to your newly added benchmark and click **Run** in the
  bottom-right corner.
- Wait for the benchmark to complete.
- If all goes well, the benchmark completion time should appear in the table for
  all enabled benchmarks (and all relevant metrics). Metrics that were disabled
  on a specific benchmarks will not display any result.

If the benchmark works as expected, congratulations! You can now open a pull request for it :)
