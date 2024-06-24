extends Benchmark

const GODOT_PATH := "/home/emmanouil/Documents/Godot_v4.3-beta2_linux.x86_64"


func open_project(path: String, path_to_delete := "") -> void:
	var root_project_path := DirAccess.open(".").get_current_dir()
	var project_path := root_project_path.path_join(path)
	OS.execute(GODOT_PATH, ["--verbose", "-e", "--quit", "--path", project_path])
	if not path_to_delete.is_empty():
		resursive_file_delete(path_to_delete)


func resursive_file_delete(path: String) -> void:
	var root_project_path := DirAccess.open(".").get_current_dir()
	var project_path := root_project_path.path_join(path)
	var dir := DirAccess.open(project_path)
	for file in dir.get_files():
		dir.remove(file)
	for subdir in dir.get_directories():
		resursive_file_delete(path.path_join(subdir))


func benchmark_start_editor_no_shader_cache() -> void:
	var path := "supplemental/projects/no_shader_cache"
	open_project(path, path.path_join(".godot/shader_cache"))


func benchmark_start_editor_shader_cache() -> void:
	open_project("supplemental/projects/shader_cache")
