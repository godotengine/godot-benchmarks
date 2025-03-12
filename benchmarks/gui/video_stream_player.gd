extends Benchmark

func _init() -> void:
	test_render_cpu = true
	test_render_gpu = true

class TheoraVideoStreamPlayer:
	extends VideoStreamPlayer

	func _init(file: String) -> void:
		var theora_stream := VideoStreamTheora.new()
		theora_stream.file = file
		stream = theora_stream
		autoplay = true

func benchmark_theora_big_buck_bunny() -> VideoStreamPlayer:
	# Source: https://commons.wikimedia.org/wiki/File:Big_Buck_Bunny_first_23_seconds_1080p.ogv
	return TheoraVideoStreamPlayer.new("res://supplemental/video/big_buck_bunny_first_23_seconds_1080p.ogv")

func benchmark_theora_space_shuttle() -> VideoStreamPlayer:
	# Source: https://commons.wikimedia.org/wiki/File:STS-132_Liftoff_Space_Shuttle_Atlantis.ogv
	# Re-recorded short clip with VLC
	return TheoraVideoStreamPlayer.new("res://supplemental/video/liftoff_space_shuttle_atlantis.ogv")
