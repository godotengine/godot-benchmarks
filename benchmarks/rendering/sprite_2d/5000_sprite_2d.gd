extends "res://benchmarks/rendering/sprite_2d/sprite_2d_base.gd"

const NUMBER_OF_SPRITES = 5_000


func _ready() -> void:
	fill_with_sprites(NUMBER_OF_SPRITES)
