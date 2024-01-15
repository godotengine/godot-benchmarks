extends Benchmark

func _init():
	test_render_cpu = true
	test_render_gpu = true


class TestScene extends Node3D:
	
	var sponza_scene = preload("res://benchmarks/rendering/sponza.tscn")
	var sponza
	
	var using_directional_light: bool
	var using_omni_lights: bool
	
	func _init():
		sponza = sponza_scene.instantiate()
		add_child(sponza)
	
	func with_directional_light():
		using_directional_light = true
		return self
		
	func with_omni_lights():
		using_omni_lights = true
		return self
		
	func _ready():
		$"Sponza/DirectionalLight3D".visible = using_directional_light
		$"Sponza/OmniLights".visible = using_omni_lights

	func _process(delta):
		pass

	func _exit_tree():
		RenderingServer.free_rid(sponza)


func benchmark_sponza_ambient():
	return TestScene.new()
	
func benchmark_sponza_directional():
	return TestScene.new().with_directional_light()
	
func benchmark_sponza_omni():
	return TestScene.new().with_omni_lights()

