extends Benchmark

const TEMP_PATH := "user://tmp"
const IMAGE_PATH_BASE := "res://supplemental/images"
const AUDIO_PATH_BASE := "res://supplemental/audio"
const IMAGE_PATH_CHECK := IMAGE_PATH_BASE + "/0.webp"
const AUDIO_PATH_CHECK := AUDIO_PATH_BASE + "/bookClose.ogg"

var glb_model_path := "res://thirdparty/sponza/sponza.glb"
var fbx_model_path := "res://thirdparty/sponza/sponza.fbx"
var image_path := IMAGE_PATH_BASE
var audio_path := AUDIO_PATH_BASE


func _init() -> void:
	# The feature is added by `addons/export_runtime_assets/export_runtime_assets.gd`.
	if OS.has_feature("pck_assets"):
		# Only fallback to using assets from PCK if the file doesn't exist.
		if not FileAccess.file_exists(glb_model_path):
			glb_model_path = "res://thirdparty/sponza/raw_assets/sponza.glb"
		if not FileAccess.file_exists(fbx_model_path):
			fbx_model_path = "res://thirdparty/sponza/raw_assets/sponza.fbx"
		if not FileAccess.file_exists(IMAGE_PATH_CHECK):
			image_path = image_path.path_join("raw_assets")
		if not FileAccess.file_exists(AUDIO_PATH_CHECK):
			audio_path = audio_path.path_join("raw_assets")

	# Silence the warning from `Image.load_from_file` being used in the 
	# editor binary with "res://" paths.
	if OS.has_feature("editor"):
		image_path = ProjectSettings.globalize_path(image_path)


func benchmark_import_gltf() -> void:
	var gltf_document := GLTFDocument.new()
	var gltf_state := GLTFState.new()
	gltf_document.append_from_file(glb_model_path, gltf_state)


func benchmark_import_fbx() -> void:
	var fbx_document := FBXDocument.new()
	var fbx_state := FBXState.new()
	fbx_document.append_from_file(fbx_model_path, fbx_state)


func benchmark_export_gltf() -> void:
	var gltf_document := GLTFDocument.new()
	var gltf_state := GLTFState.new()
	gltf_document.append_from_file(glb_model_path, gltf_state)
	DirAccess.make_dir_absolute(TEMP_PATH)
	gltf_document.write_to_filesystem(gltf_state, "user://tmp/sponza.glb")
	DirAccess.remove_absolute(TEMP_PATH.path_join("sponza.glb"))
	DirAccess.remove_absolute(TEMP_PATH)


func benchmark_import_webp_images() -> void:
	for i in 200:
		Image.load_from_file(image_path.path_join("%d.webp" % i))


func benchmark_import_ogg_audio() -> void:
	var dir := DirAccess.open(audio_path)
	for file in dir.get_files():
		if not file.get_extension() == "ogg":
			continue
		AudioStreamOggVorbis.load_from_file(audio_path.path_join(file))
