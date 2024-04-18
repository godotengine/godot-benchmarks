extends Benchmark

const VIEWPORT_SIZE = 512

func _init() -> void:
	pass


static func create_viewports(count: int) -> Array[SubViewport]:
	var viewports : Array[SubViewport] = []
	for i in range(count):
		var vp := SubViewport.new()
		vp.size = Vector2.ONE * VIEWPORT_SIZE
		viewports.append(vp)
	return viewports


static func free_items(items: Array):
	for item in items:
		item.free()


func benchmark_create_64_viewports():
	free_items(create_viewports(64))


func benchmark_create_256_viewports():
	free_items(create_viewports(256))


func benchmark_create_1024_viewports():
	free_items(create_viewports(1024))
