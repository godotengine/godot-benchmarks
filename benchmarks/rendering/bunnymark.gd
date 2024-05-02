extends Benchmark

func _init() -> void:
	test_render_cpu = true
	test_render_gpu = true

class Bunnymark extends Node2D:
	var cam := Camera2D.new()
	var texture := preload("res://supplemental/bunny.png")
	var mi2d := preload("res://supplemental/bunny_meshinstance2d.tscn")
	var rng := RandomNumberGenerator.new()
	var gravity := Vector2(0.0, 980.0)

	var count := 1
	var canvasitem_draw_api := false
	var meshinstance2d := false

	var nodes := []
	var speeds := []
	var positions := []
	var hues := []

	func _init(settings: Dictionary) -> void:
		count = settings.get("count", 1)
		canvasitem_draw_api = settings.get("canvasitem_draw_api", false)
		meshinstance2d = settings.get("meshinstance2d", false)

	func _ready() -> void:
		create_nodes()
		add_child(cam)

	func create_nodes() -> void:
		for i in count:
			var node
			if not meshinstance2d:
				node = Sprite2D.new()
			else:
				node = mi2d.instantiate()

			hues.append(Color.from_hsv(
				rng.randf_range(0.0, 1.0),
				0.8,
				0.8))

			var speed := Vector2(
				rng.randf_range(-400.0, 400.0),
				rng.randf_range(-400.0, 400.0))
			speeds.append(speed)

			positions.append(Vector2(0, 0))
			if not canvasitem_draw_api:
				if not meshinstance2d:
					node.texture = texture
				node.self_modulate = hues[i]
				nodes.append(node)
				add_child(node)

	func _process(time: float) -> void:
		for i in count:
			var spd = speeds[i]
			var pos = positions[i]

			var x_delta = abs(pos.x - 0)
			if x_delta > 400:
				spd *= Vector2(-1, 1)

			var floor_delta = pos.y - 400
			if floor_delta > 0:
				positions[i] += Vector2(0, -2*floor_delta)
				spd *= Vector2(1, -1)

			spd += gravity * time
			speeds[i] = spd
			positions[i] += time*spd

		if not canvasitem_draw_api:
			for i in count:
				var pos = positions[i]
				var node = nodes[i]
				node.transform.origin = pos
		else:
			queue_redraw()

	func _draw() -> void:
		if not canvasitem_draw_api:
			return

		for i in count:
			var pos = positions[i]
			draw_texture(texture, pos, hues[i])

func benchmark_bunnymark_canvasitem_draw_api_05_000() -> Node2D:
	return Bunnymark.new({ count = 5000, canvasitem_draw_api = true })

func benchmark_bunnymark_canvasitem_draw_api_10_000() -> Node2D:
	return Bunnymark.new({ count = 10000, canvasitem_draw_api = true })

func benchmark_bunnymark_canvasitem_draw_api_20_000() -> Node2D:
	return Bunnymark.new({ count = 20000, canvasitem_draw_api = true })


func benchmark_bunnymark_meshinstance2d_05_000() -> Node2D:
	return Bunnymark.new({ count = 5000, meshinstance2d = true })

func benchmark_bunnymark_meshinstance2d_10_000() -> Node2D:
	return Bunnymark.new({ count = 10000, meshinstance2d = true })

func benchmark_bunnymark_meshinstance2d_20_000() -> Node2D:
	return Bunnymark.new({ count = 20000, meshinstance2d = true })


func benchmark_bunnymark_sprite2d_05_000() -> Node2D:
	return Bunnymark.new({ count = 5000 })

func benchmark_bunnymark_sprite2d_10_000() -> Node2D:
	return Bunnymark.new({ count = 10000 })

func benchmark_bunnymark_sprite2d_20_000() -> Node2D:
	return Bunnymark.new({ count = 20000 })
