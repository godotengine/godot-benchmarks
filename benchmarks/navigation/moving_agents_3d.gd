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
	var visualize: bool
	var agents: Array[Node3D]

	func _init(_n_of_agents: int, _visualize: bool) -> void:
		n_of_agents = _n_of_agents
		visualize = _visualize

	func _ready() -> void:
		sponza = SPONZA_SCENE.instantiate()
		add_child(sponza)
		sponza.get_node("DirectionalLight3D").queue_free()
		sponza.get_node("OmniLights").queue_free()
		sponza.get_node("Camera3D").current = visualize
		var nav_region := NavigationRegion3D.new()
		nav_region.navigation_mesh = NAVMESH
		sponza.add_child(nav_region)

		var mesh := CapsuleMesh.new()
		mesh.radial_segments = 4
		mesh.rings = 0
		mesh.height = 0.75
		mesh.radius = 0.25
		var material := StandardMaterial3D.new()
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mesh.material = material

		for i in n_of_agents:
			var agent_parent := Node3D.new()
			agent_parent.position = _rand_pos()
			var agent := NavigationAgent3D.new()
			agent.avoidance_enabled = true
			agent.target_position = _rand_pos()
			agent_parent.add_child(agent)
			sponza.add_child(agent_parent)
			agents.append(agent_parent)
			if visualize:
				var mesh_instance := MeshInstance3D.new()
				mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
				mesh_instance.mesh = mesh
				agent_parent.add_child(mesh_instance)

	func _physics_process(delta: float) -> void:
		if NavigationServer3D.map_get_iteration_id(get_world_3d().navigation_map) == 0:
			return
		for agent in agents:
			var nav_agent := agent.get_child(0) as NavigationAgent3D
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
	return TestScene.new(1000, true)
