extends Benchmark


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
	DirAccess.make_dir_absolute("user://tmp")
	gltf_document.write_to_filesystem(gltf_state, "user://tmp/sponza.glb")
	DirAccess.remove_absolute("user://tmp/sponza.glb")
	DirAccess.remove_absolute("user://tmp")


func benchmark_import_images() -> void:
	for i in 200:
		load("res://supplemental/images/%d.webp" % i)
