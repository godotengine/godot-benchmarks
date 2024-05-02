extends Benchmark

func _init() -> void:
	test_render_cpu = true
	test_render_gpu = true

class Bunnymark extends Node2D:
	var cam := Camera2D.new()
	var icon := preload("res://icon.png")
	var rng := RandomNumberGenerator.new()
	var gravity := Vector2(0.0, 980.0)

	var count := 1
	var sprites := []
	var speeds := []

	func _init(settings: Dictionary) -> void:
		count = settings.get("count", 1)

	func _ready() -> void:
		create_sprites()
		add_child(cam)

	func create_sprites() -> void:
		for i in count:
			var sprite := Sprite2D.new()
			sprite.texture = icon
			sprite.scale = Vector2(0.2, 0.2)
			sprite.self_modulate = Color.from_hsv(
				rng.randf_range(0.0, 1.0),
				0.8,
				0.8)
			var speed := Vector2(
				rng.randf_range(-400.0, 400.0),
				rng.randf_range(-400.0, 400.0))
			sprites.append(sprite)
			add_child(sprite)
			speeds.append(speed)

	func _process(time: float) -> void:
		for i in count:
			var spr = sprites[i]
			var spd = speeds[i]

			spr.translate(spd * time)

			var x_delta = abs(spr.transform.origin.x - 0)
			if x_delta > 400:
				spd *= Vector2(-1, 1)

			var floor_delta = spr.transform.origin.y - 400
			if floor_delta > 0:
				spr.translate(Vector2(0, -2*floor_delta))
				spd *= Vector2(1, -1)

			spd += gravity * time
			speeds[i] = spd


func benchmark_bunnymark_sprite2d_05_000() -> Node2D:
	return Bunnymark.new({ count = 5000 })

func benchmark_bunnymark_sprite2d_10_000() -> Node2D:
	return Bunnymark.new({ count = 10000 })

func benchmark_bunnymark_sprite2d_20_000() -> Node2D:
	return Bunnymark.new({ count = 20000 })

func benchmark_bunnymark_sprite2d_40_000() -> Node2D:
	return Bunnymark.new({ count = 40000 })
