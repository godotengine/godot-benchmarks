@tool
extends EditorPlugin

var runtime_assets_exporter: RuntimeAssetsExporter


func _enter_tree() -> void:
	runtime_assets_exporter = RuntimeAssetsExporter.new()
	add_export_plugin(runtime_assets_exporter)


func _exit_tree() -> void:
	remove_export_plugin(runtime_assets_exporter)
	runtime_assets_exporter = null


class RuntimeAssetsExporter extends EditorExportPlugin:
	func _get_name() -> String:
		return "RuntimeAssetsExporter"


	func _export_file(path: String, type: String, features: PackedStringArray) -> void:
		if !path.begins_with("res://thirdparty") && !path.begins_with("res://supplemental"):
			return

		if not path.get_extension() in ["glb", "fbx", "webp", "ogg"]:
			return

		var bytes := FileAccess.get_file_as_bytes(path)
		if bytes.size():
			add_file(path.get_base_dir().path_join("raw_assets").path_join(path.get_file()), bytes, false)


	func _get_export_features(_platform: EditorExportPlatform, _debug: bool) -> PackedStringArray:
		return ["pck_assets"]
