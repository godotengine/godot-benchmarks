extends Node

const ITERATIONS = 80_000


func _ready():
	var array: Array[int] = []
	for i in ITERATIONS:
		# Insert elements.
		array.push_back(i)

	for i in ITERATIONS:
		# Update elements in order.
		array[i] = 0

	for i in ITERATIONS:
		# Delete elements from the front (non-constant complexity).
		array.pop_front()

	Manager.end_test()
