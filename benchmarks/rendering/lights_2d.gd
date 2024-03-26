extends Benchmark

# Benchmarks 2D lights.
enum LIGHTTYPE {POINT2D, DIRECTIONAL2D}

func _init() -> void:
	test_render_cpu = true
	test_render_gpu = true

class TestLights2D extends Node2D:
	var cam := Camera2D.new()
	
	var light_type = LIGHTTYPE.POINT2D
	var light_count = 1
	var use_shadows = false
	var sprite_count = 9
	
	func _init(settings : Dictionary):
		light_type = settings.get("light_type", LIGHTTYPE.POINT2D)
		light_count = settings.get("count", 1)
		use_shadows = settings.get("shadows", false)
	
	func _ready():
		create_backgrounds()
		
		# add sprites
		create_sprites()
		
		# create lights
		match light_type:
			LIGHTTYPE.POINT2D:
				create_point_light_2d()
			LIGHTTYPE.DIRECTIONAL2D:
				create_directional_light_2d()
	
		add_child(cam)
	
	func create_backgrounds():
		var ss = get_viewport_rect().size
		var top_left_pos = Vector2(ss.x / 2, ss.y / 2) * -1
		var rows = 5
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
		var center_point = get_viewport_rect().size / 2
		var count = round(sqrt(sprite_count))
		var radius = 250
		var sprite_size = 50
		var angle_increment = 2 * PI / sprite_count
		
		for i in range(sprite_count):
			var angle = i * angle_increment
			var x = radius * cos(angle)
			var y = radius * sin(angle)

			var s := ColorRect.new()
			s.color = Color(0.4,0.4,0.4,1)
			s.size = Vector2(sprite_size, sprite_size)
			s.position = Vector2(x - sprite_size / 2, y - sprite_size / 2)
			
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
		var center_point = get_viewport_rect().size / 2
		var radius = 300
		var angle_increment = 360.0 / light_count
		
		for i in range(light_count):
			var angle_rad = deg_to_rad(i * angle_increment)
			var x = radius * cos(angle_rad)
			var y = radius * sin(angle_rad)
			
			var light := PointLight2D.new()
			light.texture = preload("res://2d_point_light_texture.png")
			light.shadow_enabled = use_shadows
			light.energy = 5
			light.position = Vector2(x, y)
			add_child(light)
		
	func create_directional_light_2d():
		var light := DirectionalLight2D.new()
		light.shadow_enabled = use_shadows
		add_child(light)

func benchmark_directional_light_2d_without_shadows() -> Node2D:
	return TestLights2D.new({light_type=LIGHTTYPE.DIRECTIONAL2D, shadows=false})
	
func benchmark_directional_light_2d_with_shadows() -> Node2D:
	return TestLights2D.new({light_type=LIGHTTYPE.DIRECTIONAL2D, shadows=true})

func benchmark_50_point_light_2d_without_shadows() -> Node2D:
	return TestLights2D.new({light_type=LIGHTTYPE.POINT2D, count=50, shadows=false})

func benchmark_50_point_light_2d_with_shadows() -> Node2D:
	return TestLights2D.new({light_type=LIGHTTYPE.POINT2D, count=50, shadows=true})
