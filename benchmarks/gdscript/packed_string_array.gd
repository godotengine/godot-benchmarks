extends Node

const ITERATIONS = 80_000


func _ready() -> void:
	var array := PackedStringArray()
	for i in ITERATIONS:
		# Insert elements.
		array.push_back(str("Godot ", i))

	for i in ITERATIONS:
		# Update elements in order.
		array[i] = ""

	for _i in ITERATIONS:
		# Delete elements from the front (non-constant complexity).
		array.remove_at(0)

	Manager.end_test()
