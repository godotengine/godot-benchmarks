extends Benchmark

func _init():
	test_render_cpu = true
	test_render_gpu = true


class TestScene extends Node3D:

	var scene = preload("res://supplemental/very_large_scene.tscn")
	var instance
	var world_env: WorldEnvironment = null

	var using_sdfgi: bool

	func _init():
		instance = scene.instantiate()
		add_child(instance)

	func with_sdfgi():
		using_sdfgi = true
		return self

	func _ready():
		var env: Environment = null

		if using_sdfgi:
			env = Environment.new()
			env.sdfgi_enabled = true

		if env != null:
			world_env = WorldEnvironment.new()
			world_env.environment = env
			$VeryLargeScene/Camera3D.environment = env
			add_child(world_env)

	func _process(delta):
		pass

	func _exit_tree():
		if world_env != null:
			RenderingServer.free_rid(world_env)
		RenderingServer.free_rid(instance)

func benchmark_camera_motion_without_sdfgi():
	return TestScene.new()
func benchmark_camera_motion_with_sdfgi():
	return TestScene.new().with_sdfgi()
