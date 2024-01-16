extends Benchmark

func _init():
	test_render_cpu = true
	test_render_gpu = true


class TestScene extends Node3D:
	
	var sponza_scene = preload("res://benchmarks/rendering/sponza.tscn")
	var sponza
	
	var using_directional_light: bool
	var using_omni_lights: bool
	var using_dof: bool
	var dof_bokeh_shape: RenderingServer.DOFBokehShape
	
	func _init():
		sponza = sponza_scene.instantiate()
		add_child(sponza)
	
	func with_directional_light():
		using_directional_light = true
		return self
		
	func with_omni_lights():
		using_omni_lights = true
		return self
		
	func with_dof(shape: RenderingServer.DOFBokehShape):
		using_dof = true
		dof_bokeh_shape = shape
		return self
		
	func _ready():
		$"Sponza/DirectionalLight3D".visible = using_directional_light
		$"Sponza/OmniLights".visible = using_omni_lights
		
		if using_dof:
			var cam_attrs = CameraAttributesPractical.new()
			cam_attrs.dof_blur_near_enabled = true
			cam_attrs.dof_blur_far_enabled = true
			$"Sponza/Camera3D".attributes = cam_attrs
			RenderingServer.camera_attributes_set_dof_blur_bokeh_shape(dof_bokeh_shape)

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

func benchmark_sponza_dof_box():
	return TestScene.new().with_dof(RenderingServer.DOF_BOKEH_BOX)

func benchmark_sponza_dof_hex():
	return TestScene.new().with_dof(RenderingServer.DOF_BOKEH_HEXAGON)

func benchmark_sponza_dof_circle():
	return TestScene.new().with_dof(RenderingServer.DOF_BOKEH_CIRCLE)
