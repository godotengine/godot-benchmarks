extends Node2D

var Sprite := preload("res://benchmarks/rendering/sprite_2d/_sprite.tscn") as PackedScene
var sprites := []
var sprite_xforms := []

func fill_with_sprites(sprite_amount: int) -> void:
	var cam := $Camera2D as Camera2D
	var ss := get_tree().root.size
	var center := cam.get_screen_center_position()
	for i in sprite_amount:
		var xf := Transform2D()
		xf.origin = Vector2(center.x + randf() * ss.x, center.y + randf() * ss.y)
		var new_sprite = Sprite.instantiate() as Sprite2D
		call_deferred("add_child", new_sprite)
		new_sprite.set_global_transform(xf)
		
		sprites.append(new_sprite)
		sprite_xforms.append(xf)


func _exit_tree() -> void:
	for sprite in sprites:
		sprite.queue_free()
