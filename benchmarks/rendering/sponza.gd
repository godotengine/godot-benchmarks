extends Benchmark

func _init():
	test_render_cpu = true
	test_render_gpu = true


class TestScene extends Node3D:

	var sponza_scene = preload("res://supplemental/sponza.tscn")
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

	var using_fsr2_100: bool
	var using_fsr2_50: bool
	var using_fxaa: bool
	var using_msaa2x: bool
	var using_msaa4x: bool
	var using_taa: bool

	var viewport_rid: RID

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

	func with_fsr2_100():
		using_fsr2_100 = true
		return self

	func with_fsr2_50():
		using_fsr2_50 = true
		return self

	func with_fxaa():
		using_fxaa = true
		return self

	func with_msaa2x():
		using_msaa2x = true
		return self

	func with_msaa4x():
		using_msaa4x = true
		return self

	func with_taa():
		using_taa = true
		return self

	func _ready():
		$"Sponza/DirectionalLight3D".visible = using_directional_light
		$"Sponza/OmniLights".visible = using_omni_lights

		viewport_rid = get_window().get_viewport_rid()

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
		if using_fsr2_100:
			RenderingServer.viewport_set_scaling_3d_mode(viewport_rid, RenderingServer.VIEWPORT_SCALING_3D_MODE_FSR2)
			RenderingServer.viewport_set_scaling_3d_scale(viewport_rid, 1.0);
		if using_fsr2_50:
			RenderingServer.viewport_set_scaling_3d_mode(viewport_rid, RenderingServer.VIEWPORT_SCALING_3D_MODE_FSR2)
			RenderingServer.viewport_set_scaling_3d_scale(viewport_rid, 0.5);
		if using_fxaa:
			RenderingServer.viewport_set_screen_space_aa(viewport_rid, RenderingServer.VIEWPORT_SCREEN_SPACE_AA_FXAA)
		if using_msaa2x:
			RenderingServer.viewport_set_msaa_3d(viewport_rid, RenderingServer.VIEWPORT_MSAA_2X)
		if using_msaa4x:
			RenderingServer.viewport_set_msaa_3d(viewport_rid, RenderingServer.VIEWPORT_MSAA_4X)
		if using_taa:
			RenderingServer.viewport_set_use_taa(viewport_rid, true)

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

		if using_fsr2_100 or using_fsr2_50:
			RenderingServer.viewport_set_scaling_3d_mode(viewport_rid, RenderingServer.VIEWPORT_SCALING_3D_MODE_BILINEAR)
			RenderingServer.viewport_set_scaling_3d_scale(viewport_rid, 1.0);
		if using_fxaa:
			RenderingServer.viewport_set_screen_space_aa(viewport_rid, RenderingServer.VIEWPORT_SCREEN_SPACE_AA_DISABLED)
		if using_msaa2x or using_msaa4x:
			RenderingServer.viewport_set_msaa_3d(viewport_rid, RenderingServer.VIEWPORT_MSAA_DISABLED)
		if using_taa:
			RenderingServer.viewport_set_use_taa(viewport_rid, false)


func benchmark_basic_ambient():
	return TestScene.new()

func benchmark_basic_directional():
	return TestScene.new().with_directional_light()

func benchmark_basic_omni():
	return TestScene.new().with_omni_lights()

func benchmark_dof_box():
	return TestScene.new().with_dof(RenderingServer.DOF_BOKEH_BOX)

func benchmark_dof_hex():
	return TestScene.new().with_dof(RenderingServer.DOF_BOKEH_HEXAGON)

func benchmark_dof_circle():
	return TestScene.new().with_dof(RenderingServer.DOF_BOKEH_CIRCLE)

func benchmark_effect_glow():
	return (TestScene.new()
		.with_directional_light()
		.with_glow())

func benchmark_effect_ssao():
	return (TestScene.new()
		.with_directional_light()
		.with_ssao())

func benchmark_effect_ssr():
	return (TestScene.new()
		.with_directional_light()
		.with_ssr())

func benchmark_effect_volumetric_fog():
	return (TestScene.new()
		.with_directional_light()
		.with_volumetric_fog())

func benchmark_aa_fsr2_100():
	return (TestScene.new()
		.with_fsr2_100())

func benchmark_aa_fsr2_50():
	return (TestScene.new()
		.with_fsr2_50())

func benchmark_aa_fxaa():
	return (TestScene.new()
		.with_fxaa())

func benchmark_aa_msaa2x():
	return (TestScene.new()
		.with_msaa2x())

func benchmark_aa_msaa4x():
	return (TestScene.new()
		.with_msaa4x())

func benchmark_aa_taa():
	return (TestScene.new()
		.with_taa())
