extends Benchmark

const ICON := preload("res://icon.png")
const NAVPOLYGON := preload("res://supplemental/navigation_polygon.res")
const SPREAD_H := 680.0
const SPREAD_V := 540.0
const AGENT_SPEED := 50.0


class TestScene:
	extends Node2D

	var n_of_agents: int
	var visualize: bool
	var agents: Array[Node2D]

	func _init(_n_of_agents: int, _visualize: bool) -> void:
		n_of_agents = _n_of_agents
		visualize = _visualize

	func _ready() -> void:
		var nav_region := NavigationRegion2D.new()
		nav_region.navigation_polygon = NAVPOLYGON
		add_child(nav_region)

		for i in n_of_agents:
			var agent_parent := Node2D.new()
			agent_parent.position = _rand_pos()
			var agent := NavigationAgent2D.new()
			agent.avoidance_enabled = true
			agent.target_position = _rand_pos()
			agent_parent.add_child(agent)
			add_child(agent_parent)
			agents.append(agent_parent)
			if visualize:
				var sprite := Sprite2D.new()
				sprite.scale = Vector2(0.1, 0.1)
				sprite.texture = ICON
				agent_parent.add_child(sprite)

	func _physics_process(delta: float) -> void:
		if NavigationServer2D.map_get_iteration_id(get_world_2d().navigation_map) == 0:
			return
		for agent in agents:
			var nav_agent := agent.get_child(0) as NavigationAgent2D
			if nav_agent.is_navigation_finished():
				continue
			var next_position := nav_agent.get_next_path_position()
			agent.global_position = agent.global_position.move_toward(
				next_position, delta * AGENT_SPEED
			)

	func _rand_pos() -> Vector2:
		return Vector2(randf_range(0.0, SPREAD_H), randf_range(0.0, SPREAD_V))


func _init() -> void:
	test_render_cpu = true


func benchmark_1000_moving_agents() -> TestScene:
	return TestScene.new(1000, false)
