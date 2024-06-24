extends Benchmark

const SPREAD_H := 16.0
const SPREAD_V := 10.0


class TestScene:
	extends Node3D

	const MANNEQUINY := preload("res://supplemental/mannequiny.tscn")
	var models: Array[Node3D]
	var n_of_models: int
	var visualize := true
	var using_state_machine := false
	var using_blend_tree := false

	func _init(_n_of_models: int, _visualize: bool) -> void:
		n_of_models = _n_of_models
		visualize = _visualize

	func _ready() -> void:
		for i in n_of_models:
			var mannequiny_node := MANNEQUINY.instantiate() as Node3D
			mannequiny_node.position = Vector3(
				randf_range(-SPREAD_H, SPREAD_H),
				randf_range(0.0, SPREAD_V),
				randf_range(-SPREAD_H, SPREAD_H)
			)
			var animation_tree: AnimationTree
			if using_state_machine:
				animation_tree = mannequiny_node.get_node(^"AnimationTreeState")
				animation_tree.active = true
				var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
				_random_state(playback)
			if using_blend_tree:
				animation_tree = mannequiny_node.get_node(^"AnimationTreeBlend")
				animation_tree.active = true
				animation_tree["parameters/Idle/blend_position"] = randf_range(0.0, 0.3)
				animation_tree["parameters/IdleOrRun/blend_amount"] = randf()
			add_child(mannequiny_node)
			models.append(mannequiny_node)
		if visualize:
			var camera := Camera3D.new()
			camera.position = Vector3(0.0, 20.0, 20.0)
			camera.rotate_x(-0.8)
			add_child(camera)

	func _process(_delta: float) -> void:
		for model in models:
			var chance := randi() % 200  # Chance to change animation
			var animation_tree: AnimationTree
			if using_state_machine:
				animation_tree = model.get_node(^"AnimationTreeState")
				if chance <= 10:
					var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
					_random_state(playback)
			if using_blend_tree:
				animation_tree = model.get_node(^"AnimationTreeBlend")
				if chance == 0:
					animation_tree["parameters/OneShotDash/request"] = (
						AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
					)
				elif chance == 1:
					animation_tree["parameters/OneShotKick/request"] = (
						AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
					)
				elif chance == 2:
					animation_tree["parameters/OneShotPunch/request"] = (
						AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
					)

	func _random_state(playback: AnimationNodeStateMachinePlayback) -> void:
		var random_state := randi() % 7
		match random_state:
			0:
				playback.travel(&"idle")
			1:
				playback.travel(&"run")
			2:
				playback.travel(&"jump")
			3:
				playback.travel(&"land")
			4:
				playback.travel(&"dash")
			5:
				playback.travel(&"fight_kick")
			6:
				playback.travel(&"fight_punch")

	func with_state_machine() -> TestScene:
		using_state_machine = true
		return self

	func with_blend_tree() -> TestScene:
		using_blend_tree = true
		return self


func _init() -> void:
	test_render_cpu = true
	test_render_gpu = true

func benchmark_animation_state_machine_1000() -> TestScene:
	return TestScene.new(1000, true).with_state_machine()


func benchmark_animation_blend_tree_100() -> TestScene:
	return TestScene.new(100, true).with_blend_tree()
