extends Benchmark

# Benchmarks interaction between lights and meshes.

var box_mesh = null
var sphere_mesh = null


func _init() -> void:
	test_render_cpu = true
	test_render_gpu = true

	box_mesh = BoxMesh.new()
	sphere_mesh = SphereMesh.new()


class Rotater extends Node3D:
	var speed := 1.0
	func _init(_speed: float):
		speed = _speed
	func _process(delta: float) -> void:
		rotate_y(delta * speed)

# Toggles visibility of child light
class Lighter extends Node3D:
	var accum := 0.0
	var light = null
	var speed := 1.0
	func _init(_light, _speed):
		light = _light
		speed = _speed
		add_child(light)
		accum = randf() * 100
	func _process(delta: float) -> void:
		accum += delta * speed * 2.0
		var energy := sin(accum) * 5.0
		light.visible = energy > 0
		if light.visible:
			light.light_energy = energy

func create_scattered(count: int) -> Node3D:
	var rt := Node3D.new()
	var s : float = round(sqrt(count))
	for z in s:
		for x in s:
			var child := Node3D.new()
			child.position.x = (randf() * 0.1 + x + 0.5) * 2 / s - 1
			child.position.z = (randf() * 0.1 + z + 0.5) * 2 / s - 1
			child.position.y = -randf() * 0.1 / s
			child.scale.x *= 2/s
			child.scale.z *= 2/s
			rt.add_child(child)
	return rt

func create_omni_light():
	var light := OmniLight3D.new()
	light.position.y = 0.01
	light.omni_attenuation = 0.1
	light.omni_range = 0.1
	light.light_energy = 5.0
	light.light_size = 0.1
	return light

func create_spot_light():
	var light := SpotLight3D.new()
	light.position.y = 0.01
	light.spot_attenuation = 0.2
	light.spot_angle = 25
	light.spot_range = 0.4
	light.light_energy = 5.0
	light.rotation.y = randf() * 999999
	light.light_size = 0.1
	return light


func create_scene(settings : Dictionary) -> Node3D:
	var mesh = settings.get("mesh", box_mesh)
	var objects = settings.get("objects", 1000)
	var create_light = settings.get("create_light", create_spot_light)
	var lights = settings.get("lights", 10)
	var speed = settings.get("speed", 1.0)

	var scene_root := Node3D.new()
	var cam := Camera3D.new()
	cam.position.y = 0.3
	cam.position.z = 1.0
	cam.rotate_x(-.8)
	scene_root.add_child(cam)

	var mesh_grid := create_scattered(objects)
	for i in mesh_grid.get_child_count():
		var model := MeshInstance3D.new()
		model.scale.y = 0.05
		model.position.y = -0.025
		model.mesh = mesh
		mesh_grid.get_child(i).add_child(model)

	var light_grid := create_scattered(lights)
	for i in light_grid.get_child_count():
		light_grid.get_child(i).add_child(Lighter.new(create_light.call(), speed))

	# Rotate in opposite directions so that
	# lights-to-meshes pairings change over time
	var mesh_rotater := Rotater.new(-0.1 * speed)
	mesh_rotater.add_child(mesh_grid)
	scene_root.add_child(mesh_rotater)

	var light_rotater := Rotater.new(0.1 * speed)
	light_rotater.add_child(light_grid)
	scene_root.add_child(light_rotater)

	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color("#fff")
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	scene_root.add_child(env)
	return scene_root


func benchmark_box_100() -> Node3D:
	return create_scene({mesh=box_mesh,objects=100})
func benchmark_box_1000() -> Node3D:
	return create_scene({mesh=box_mesh,objects=1000})
func benchmark_box_10000() -> Node3D:
	return create_scene({mesh=box_mesh,objects=10000})

func benchmark_sphere_100() -> Node3D:
	return create_scene({mesh=sphere_mesh,objects=100})
func benchmark_sphere_1000() -> Node3D:
	return create_scene({mesh=sphere_mesh,objects=1000})
func benchmark_sphere_10000() -> Node3D:
	return create_scene({mesh=sphere_mesh,objects=10000})


func benchmark_omni_10() -> Node3D:
	return create_scene({create_light=create_omni_light,lights=10})
func benchmark_omni_100() -> Node3D:
	return create_scene({create_light=create_omni_light,lights=100})

func benchmark_spot_10() -> Node3D:
	return create_scene({create_light=create_spot_light,lights=10})
func benchmark_spot_100() -> Node3D:
	return create_scene({create_light=create_spot_light,lights=100})


func benchmark_speed_fast() -> Node3D:
	return create_scene({speed=5.0})
func benchmark_speed_slow() -> Node3D:
	return create_scene({speed=1.0})


func benchmark_stress() -> Node3D:
	return create_scene({mesh=sphere_mesh,objects=10000,lights=100,speed=5.0})

