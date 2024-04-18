extends Benchmark

# In Godot, a lot of the cost of Viewport nodes comes during activation.
# That is, when you create it, add it to the tree, set the size and allocate the viewport texture...
# The point when the underlying render target is created is a huge weak point in some GPU drivers.
const allocation = preload("./allocation.gd")


class TestScene extends Node2D:
	var viewports: Array[SubViewport] = []
	var viewports_added := false

	func _init(count: int):
		viewports = allocation.create_viewports(count)

	func _ready():
		var cl := CanvasLayer.new()
		add_child(cl)
		var i := 0
		for vp in viewports:
			var vpc = SubViewportContainer.new()
			vpc.add_child(vp)
			vpc.size = Vector2.ONE * allocation.VIEWPORT_SIZE
			cl.add_child(vpc)
			vpc.position = Vector2.ONE * ((i * 10) % 1024)
			i += 1


func activate_viewports(count: int):
	var node = TestScene.new(count)
	Manager.get_tree().root.add_child(node)
	await Manager.get_tree().process_frame
	node.free()


func benchmark_activate_64_viewports():
	await activate_viewports(64)


func benchmark_activate_256_viewports():
	await activate_viewports(256)


func benchmark_activate_1024_viewports():
	await activate_viewports(1024)
