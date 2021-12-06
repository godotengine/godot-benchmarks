extends Node

const ITERATIONS = 80_000


func _ready():
	var array = []
	for i in ITERATIONS:
		# Insert elements.
		array.push_back(i)

	for i in 50_000:
		# Update elements in order.
		array[i] = 0

	for _i in ITERATIONS:
		# Delete elements from the front (non-constant complexity).
		array.pop_front()

	Manager.end_test()
