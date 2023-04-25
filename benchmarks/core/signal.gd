extends Benchmark

signal emitter

func on_emit():
	pass

func benchmark_emission():
	emitter.connect(on_emit)
	for i in 1000_000:
		emitter.emit()
	emitter.disconnect(on_emit)
