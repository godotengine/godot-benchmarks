extends Benchmark

const TEMP_PATH := "user://tmp"
const IMAGE_PATH := "res://supplemental/images"
const AUDIO_PATH := "res://supplemental/audio"


func benchmark_import_gltf() -> void:
	var gltf_document := GLTFDocument.new()
	var gltf_state := GLTFState.new()
	gltf_document.append_from_file("res://thirdparty/sponza/sponza.glb", gltf_state)


func benchmark_import_fbx() -> void:
	var fbx_document := FBXDocument.new()
	var fbx_state := FBXState.new()
	fbx_document.append_from_file("res://thirdparty/sponza/sponza.fbx", fbx_state)


func benchmark_export_gltf() -> void:
	var gltf_document := GLTFDocument.new()
	var gltf_state := GLTFState.new()
	gltf_document.append_from_file("res://thirdparty/sponza/sponza.glb", gltf_state)
	DirAccess.make_dir_absolute(TEMP_PATH)
	gltf_document.write_to_filesystem(gltf_state, "user://tmp/sponza.glb")
	DirAccess.remove_absolute(TEMP_PATH.path_join("sponza.glb"))
	DirAccess.remove_absolute(TEMP_PATH)


func benchmark_import_webp_images() -> void:
	for i in 200:
		load(IMAGE_PATH.path_join("%d.webp" % i))


func benchmark_import_ogg_audio() -> void:
	var dir := DirAccess.open(AUDIO_PATH)
	for file in dir.get_files():
		if not file.get_extension() == "ogg":
			continue
		AudioStreamOggVorbis.load_from_file(AUDIO_PATH.path_join(file))
