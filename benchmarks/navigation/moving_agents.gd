extends Benchmark

const SPONZA_SCENE := preload("res://supplemental/sponza.tscn")
const NAVMESH := preload("res://supplemental/navmesh_sponza.tres")
const SPREAD_H := 10.0
const SPREAD_V := 10.0
const AGENT_SPEED := 1.0


class TestScene:
	extends Node3D

	var sponza: Node
	var n_of_agents: int
	var agents: Array[Node3D]

	func _init(_n_of_agents: int) -> void:
		n_of_agents = _n_of_agents

	func _ready() -> void:
		sponza = SPONZA_SCENE.instantiate()
		add_child(sponza)
		var nav_region := NavigationRegion3D.new()
		nav_region.navigation_mesh = NAVMESH
		sponza.add_child(nav_region)

		for i in n_of_agents:
			var agent_parent := MeshInstance3D.new()
			agent_parent.mesh = CapsuleMesh.new()
			agent_parent.position = _rand_pos()
			var agent := NavigationAgent3D.new()
			agent.avoidance_enabled = true
			agent.target_position = _rand_pos()
			agent_parent.add_child(agent)
			sponza.add_child(agent_parent)
			agents.append(agent_parent)

	func _physics_process(delta: float) -> void:
		if NavigationServer3D.map_get_iteration_id(get_world_3d().navigation_map) == 0:
			return
		for agent in agents:
			var nav_agent: NavigationAgent3D = agent.get_child(0)
			if nav_agent.is_navigation_finished():
				continue
			var next_position := nav_agent.get_next_path_position()
			agent.global_position = agent.global_position.move_toward(
				next_position, delta * AGENT_SPEED
			)

	func _rand_pos() -> Vector3:
		return Vector3(
			randf_range(-SPREAD_H, SPREAD_H),
			randf_range(0.0, SPREAD_V),
			randf_range(-SPREAD_H, SPREAD_H)
		)


func _init() -> void:
	test_render_cpu = true


func benchmark_1000_moving_agents() -> TestScene:
	return TestScene.new(1000)
