extends Benchmark

const TEMP_PATH := "user://tmp"
var godot_path := OS.get_executable_path()


func create_project() -> void:
	DirAccess.make_dir_absolute(TEMP_PATH)
	var project_path := TEMP_PATH.path_join("project.godot")
	FileAccess.open(project_path, FileAccess.WRITE)


func open_project() -> void:
	var temp_path_globalized := ProjectSettings.globalize_path(TEMP_PATH)
	OS.execute(godot_path, ["-e", "--quit", "--path", temp_path_globalized])


func resursive_files_delete(path: String) -> void:
	var dir := DirAccess.open(path)
	dir.include_hidden = true
	for file in dir.get_files():
		dir.remove(file)
	for subdir in dir.get_directories():
		resursive_files_delete(path.path_join(subdir))
	DirAccess.remove_absolute(path)


func recursive_files_copy(path_from: String, path_to: String) -> void:
	var dir_from := DirAccess.open(path_from)
	DirAccess.make_dir_recursive_absolute(path_to)
	for file in dir_from.get_files():
		DirAccess.copy_absolute(path_from.path_join(file), path_to.path_join(file))
	for subdir in dir_from.get_directories():
		recursive_files_copy(path_from.path_join(subdir), path_to.path_join(subdir))


func benchmark_start_editor_no_shader_cache() -> void:
	create_project()
	open_project()
	resursive_files_delete(TEMP_PATH)


func benchmark_start_editor_shader_cache() -> void:
	create_project()
	var root_project_path := "."
	var root_shader_cache_path := root_project_path.path_join(".godot/shader_cache")
	var temp_shader_cache := TEMP_PATH.path_join(".godot/shader_cache")
	recursive_files_copy(root_shader_cache_path, temp_shader_cache)
	open_project()
	resursive_files_delete(TEMP_PATH)
