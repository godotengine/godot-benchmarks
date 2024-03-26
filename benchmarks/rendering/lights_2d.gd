extends Benchmark

# Benchmarks 2D lights.
enum LIGHTTYPE {POINT2D, DIRECTIONAL2D}

func _init() -> void:
	test_render_cpu = true
	test_render_gpu = true

# Used to rotate lights to update rendering.
class Rotater extends Node2D:
	var speed := 1.0
	func _init(_speed: float):
		speed = _speed
	func _process(delta: float) -> void:
		rotation += speed * delta

class TestLights2D extends Node2D:
	var cam := Camera2D.new()
	
	var light_type = LIGHTTYPE.POINT2D
	var light_count = 1
	var use_shadows = false
	var sprite_count = 25
	
	func _init(settings : Dictionary):
		light_type = settings.get("light_type", LIGHTTYPE.POINT2D)
		use_shadows = settings.get("shadows", false)
	
	func _ready():
		create_backgrounds()
		create_sprites()
		
		match light_type:
			LIGHTTYPE.POINT2D:
				create_point_light_2d()
			LIGHTTYPE.DIRECTIONAL2D:
				create_directional_light_2d()
	
		add_child(cam)
	
	func create_backgrounds():
		var ss = get_viewport_rect().size
		var top_left_pos = Vector2(ss.x / 2, ss.y / 2) * -1
		var rows = 4
		var cols = 3
		
		# Calculate the size of each color rect based on the number of rows and columns
		var rect_width = ss.x / cols
		var rect_height = ss.y / rows

		# Create color rect objects in a grid
		for row in range(rows):
			for col in range(cols):
				var background := ColorRect.new()
				background.color = Color(0.15,0.15,0.15,1)
				background.size = Vector2(rect_width, rect_height)
				background.position = top_left_pos + Vector2(rect_width * col, rect_height * row)
				add_child(background)
	
	func create_sprites():
		var viewport_size = get_viewport_rect().size
		var sprite_size = 150
		
		var grid_rows = 4
		var grid_cols = 5
		var horizontal_spacing = (viewport_size.x - (grid_cols * sprite_size)) / (grid_cols + 1)
		var vertical_spacing = (viewport_size.y - (grid_rows * sprite_size)) / (grid_rows + 1)

		# Place color rects in a grid with variance in position
		for row in range(grid_rows):
			for col in range(grid_cols):
				var s = ColorRect.new()
				s.size = Vector2(sprite_size, sprite_size)
				s.color = Color(0.4,0.4,0.4,1)

				# Introduce random offsets for variance in position
				var variance = 50
				var random_offset_x = randf_range(-variance, variance)
				var random_offset_y = randf_range(-variance, variance)

				# Calculate the position of each color rect in the grid
				var rect_position = Vector2(
					(col + 1) * horizontal_spacing + col * sprite_size + random_offset_x,
					(row + 1) * vertical_spacing + row * sprite_size + random_offset_y
				)

				s.position = - viewport_size / 2 + rect_position
			
				if use_shadows:
						var light_occluder = LightOccluder2D.new()
						light_occluder.occluder = OccluderPolygon2D.new()
						light_occluder.occluder.polygon = PackedVector2Array([
							Vector2(0,0),
							Vector2(sprite_size,0),
							Vector2(sprite_size,sprite_size),
							Vector2(0,sprite_size)
							])
						s.add_child(light_occluder)
						
				add_child(s)
	
	func create_point_light_2d():
		var viewport_size = get_viewport_rect().size
		var grid_rows = 5
		var grid_cols = 10
		var light_size = 150
		var horizontal_spacing = (viewport_size.x - (grid_cols * light_size)) / (grid_cols + 1)
		var vertical_spacing = (viewport_size.y - (grid_rows * light_size)) / (grid_rows + 1)

		# Place color rects in a grid with variance in position
		for row in range(grid_rows):
			for col in range(grid_cols):
				var light := PointLight2D.new()
				light.texture = preload("res://2d_point_light_texture.png")
				light.shadow_enabled = use_shadows
				light.energy = 5

				# Introduce random offsets for variance in position
				var variance = 40
				var random_offset = Vector2(randf_range(-variance, variance), randf_range(-variance, variance))
				
				# Calculate the position of each color rect in the grid
				var pos = Vector2(
					(col + 1) * horizontal_spacing + col * light_size,
					(row + 1) * vertical_spacing + row * light_size
				)
				
				var parent := Rotater.new(1)
				parent.position = - viewport_size / 2 + Vector2(light_size, light_size) / 2 + pos
				add_child(parent)
				
				light.position = random_offset
				parent.add_child(light)
		
	func create_directional_light_2d():
		var light := DirectionalLight2D.new()
		light.shadow_enabled = use_shadows
		add_child(light)

func benchmark_directional_light_2d_without_shadows() -> Node2D:
	return TestLights2D.new({light_type=LIGHTTYPE.DIRECTIONAL2D, shadows=false})
	
func benchmark_directional_light_2d_with_shadows() -> Node2D:
	return TestLights2D.new({light_type=LIGHTTYPE.DIRECTIONAL2D, shadows=true})

func benchmark_50_point_light_2d_without_shadows() -> Node2D:
	return TestLights2D.new({light_type=LIGHTTYPE.POINT2D, shadows=false})

func benchmark_50_point_light_2d_with_shadows() -> Node2D:
	return TestLights2D.new({light_type=LIGHTTYPE.POINT2D, shadows=true})
