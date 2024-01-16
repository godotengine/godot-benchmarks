extends Benchmark

func _init():
	test_render_cpu = true
	test_render_gpu = true


class TestScene extends Node3D:

	var sponza_scene = preload("res://benchmarks/rendering/sponza.tscn")
	var sponza
	var world_env: WorldEnvironment = null

	var using_directional_light: bool
	var using_omni_lights: bool
	var using_dof: bool
	var dof_bokeh_shape: RenderingServer.DOFBokehShape

	var using_glow: bool
	var using_ssr: bool
	var using_ssao: bool
	var using_volumetric_fog: bool

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

	func with_glow():
		using_glow = true
		return self

	func with_ssao():
		using_ssao = true
		return self

	func with_ssr():
		using_ssr = true
		return self

	func with_volumetric_fog():
		using_volumetric_fog = true
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

		var env: Environment = null

		if using_ssr:
			env = Environment.new()
			env.ssr_enabled = true

		if using_glow:
			env = Environment.new()
			env.glow_enabled = true
			env.glow_bloom = 1.0
			for i in RenderingServer.MAX_GLOW_LEVELS - 1:
				env.set_glow_level(i + 1, 1.0)

		if using_ssao:
			env = Environment.new()
			env.ssao_enabled = true

		if using_volumetric_fog:
			env = Environment.new()
			env.volumetric_fog_enabled = true

		if env != null:
			world_env = WorldEnvironment.new()
			world_env.environment = env
			$Sponza/Camera3D.environment = env
			add_child(world_env)

	func _process(delta):
		pass

	func _exit_tree():
		if world_env != null:
			RenderingServer.free_rid(world_env)
		RenderingServer.free_rid(sponza)


func benchmark_sponza_basic_ambient():
	return TestScene.new()

func benchmark_sponza_basic_directional():
	return TestScene.new().with_directional_light()

func benchmark_sponza_basic_omni():
	return TestScene.new().with_omni_lights()

func benchmark_sponza_dof_box():
	return TestScene.new().with_dof(RenderingServer.DOF_BOKEH_BOX)

func benchmark_sponza_dof_hex():
	return TestScene.new().with_dof(RenderingServer.DOF_BOKEH_HEXAGON)

func benchmark_sponza_dof_circle():
	return TestScene.new().with_dof(RenderingServer.DOF_BOKEH_CIRCLE)

func benchmark_sponza_effect_glow():
	return (TestScene.new()
		.with_directional_light()
		.with_glow())

func benchmark_sponza_effect_ssao():
	return (TestScene.new()
		.with_directional_light()
		.with_ssao())

func benchmark_sponza_effect_ssr():
	return (TestScene.new()
		.with_directional_light()
		.with_ssr())

func benchmark_sponza_effect_volumetric_fog():
	return (TestScene.new()
		.with_directional_light()
		.with_volumetric_fog())
