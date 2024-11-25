extends Benchmark

const NUMBER_OF_OBJECTS := 1000
const NUMBER_OF_PROBES := 500


func _init() -> void:
	test_render_cpu = true
	test_render_gpu = true


class TestScene:
	extends Node3D

	var sponza_scene := preload("res://supplemental/sponza.tscn")
	var sponza: Node
	var time_accum := 0.0
	var objects: Array[MeshInstance3D]

	func _init() -> void:
		sponza = sponza_scene.instantiate()
		add_child(sponza)

	func _ready() -> void:
		$"Sponza/OmniLights".visible = false
		var lightmap := LightmapGI.new()
		lightmap.light_data = load("res://supplemental/sponza.lmbake")
		$Sponza.add_child(lightmap)

		var meshes: Array[PrimitiveMesh] = [
			BoxMesh.new(),
			SphereMesh.new(),
			CapsuleMesh.new(),
			CylinderMesh.new(),
			PrismMesh.new(),
		]
		@warning_ignore("integer_division")
		var half_objects := NUMBER_OF_OBJECTS / 2
		for i in NUMBER_OF_OBJECTS:
			var ins := MeshInstance3D.new()
			ins.gi_mode = GeometryInstance3D.GI_MODE_DYNAMIC
			ins.mesh = meshes[i % meshes.size()]
			ins.position.y = 1
			ins.position.z = i - half_objects
			$Sponza.add_child(ins)
			objects.append(ins)

	func _process(delta: float) -> void:
		time_accum += delta * 2.0
		for i in objects.size():
			objects[i].position.x = sin(time_accum) * 6.0

	func _exit_tree() -> void:
		RenderingServer.free_rid(sponza)


func benchmark_lightmap_probe_influence() -> TestScene:
	return TestScene.new()
