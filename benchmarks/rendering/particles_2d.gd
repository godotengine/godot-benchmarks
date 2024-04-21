extends Benchmark

func _init() -> void:
	test_render_cpu = true
	test_render_gpu = true

enum ParticleType {
	GPU_PARTICLES,
	CPU_PARTICLES
}


class Test2DParticles extends Node2D:
	var cam := Camera2D.new()
	var nodes: int = 1
	var particles: int = 1
	var type := ParticleType.GPU_PARTICLES
	
	func _init(settings: Dictionary) -> void:
		type = settings.get("type")
		nodes = settings.get("nodes")
		particles = settings.get("particles")
		add_child(cam)

	func _ready() -> void:
		var viewport_size := get_viewport_rect().size
		var x := viewport_size.x / 2 - 100
		var y := viewport_size.y / 2 - 100
		for i in nodes:
			var node := create_particles(GPUParticles2D.new())
			if type == ParticleType.CPU_PARTICLES:
				var cpu_node := CPUParticles2D.new()
				cpu_node.convert_from_particles(node)
				node = cpu_node
			node.position = Vector2(randf_range(-x, x), randf_range(-y, y))
			add_child(node)
			
	func create_particles(node) -> Node2D:
		node.process_material = ParticleProcessMaterial.new()
		node.process_material.spread = 180
		node.process_material.initial_velocity_min = 100
		node.process_material.initial_velocity_max = 100
		node.process_material.gravity = Vector3(0, 0, 0)
		node.texture = MeshTexture.new()
		node.texture.mesh = QuadMesh.new()
		node.texture.mesh.size = Vector2(0.1, 0.1)
		node.texture.mesh.material = StandardMaterial3D.new()
		node.texture.mesh.material.shading_mode = 0
		node.texture.mesh.material.billboard_mode = 1
		node.texture.image_size = Vector2(1, 1)
		node.amount = particles
		node.lifetime = 3
		return node


func benchmark_few_gpuparticles2d_nodes_with_many_particles() -> Node2D:
	return Test2DParticles.new({type = ParticleType.GPU_PARTICLES, nodes = 10, particles = 1000})
	
func benchmark_many_gpuparticles2d_nodes_with_few_particles() -> Node2D:
	return Test2DParticles.new({type = ParticleType.GPU_PARTICLES, nodes = 1000, particles = 10})
	
func benchmark_few_cpuparticles2d_nodes_with_many_particles() -> Node2D:
	return Test2DParticles.new({type = ParticleType.CPU_PARTICLES, nodes = 10, particles = 1000})
	
func benchmark_many_cpuparticles2d_nodes_with_few_particles() -> Node2D:
	return Test2DParticles.new({type = ParticleType.CPU_PARTICLES, nodes = 1000, particles = 10})
