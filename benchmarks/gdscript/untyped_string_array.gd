extends Node

const ITERATIONS = 80_000


func _ready():
	var array = []
	for i in ITERATIONS:
		# Insert elements.
		array.push_back(str("Godot ", i))

	for i in ITERATIONS:
		# Update elements in order.
		array[i] = ""

	for _i in ITERATIONS:
		# Delete elements from the front (non-constant complexity).
		array.pop_front()

	Manager.end_test()
