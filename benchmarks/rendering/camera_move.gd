extends Camera3D

@onready var _animation_player = $AnimationPlayer

func _ready():
	_animation_player.play("move")
