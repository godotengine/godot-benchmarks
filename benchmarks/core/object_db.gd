extends Benchmark

const NUM_OBJECTS := 1000
const ITERATIONS := 100

var threads: Array[Thread]
var sem := Semaphore.new()

func _init_threads(p_count: int, p_contention_min: float = 1.0, p_contention_max: float = 1.0):
	for i in p_count:
		var th := Thread.new()
		var duty: float
		if i == 0:
			duty = 1.0
		else:
			# Min is never reached, so 0 can be used without the last thread having 0 duties.
			duty = remap(i + 1, 0, p_count, p_contention_min, p_contention_max)
		th.start(_thread_func.bind(duty))
		threads.push_back(th)
	sem.post(threads.size())

func _term_threads():
	for th in threads:
		th.wait_to_finish()
	threads = []

func _thread_func(p_duty: float) -> void:
	var objs: Array[Object]
	objs.resize(NUM_OBJECTS)
	sem.wait()
	for i in int(ITERATIONS * p_duty):
		for j in NUM_OBJECTS:
			objs[j] = Object.new()
		for j in NUM_OBJECTS:
			objs[j].free()


func benchmark_single() -> void:
	_init_threads(1)
	_term_threads()


# In the benchmarks below, different contention terms are used:
# full - All threads run all the iterations.
# half - Threads other than the first one run half of the iterations.
# slope - Threads other than the first one run successively more work,
#         with the second thread running few iterations and
#         the last thread running almost as many as the first one.
# little - Threads other than the first one run few iterations.

func benchmark_2_threads_full_contention() -> void:
	_init_threads(2)
	_term_threads()

func benchmark_2_threads_half_contention() -> void:
	_init_threads(2, 0.5, 0.5)
	_term_threads()

func benchmark_2_threads_little_contention() -> void:
	_init_threads(2, 0.1, 0.1)
	_term_threads()


func benchmark_4_threads_full_contention() -> void:
	_init_threads(4)
	_term_threads()

func benchmark_4_threads_half_contention() -> void:
	_init_threads(4, 0.5, 0.5)
	_term_threads()

func benchmark_4_threads_slope_contention() -> void:
	_init_threads(4, 0.0, 1.0)
	_term_threads()

func benchmark_4_threads_little_contention() -> void:
	_init_threads(4, 0.1, 0.1)
	_term_threads()


func benchmark_8_threads_full_contention() -> void:
	_init_threads(8)
	_term_threads()

func benchmark_8_threads_half_contention() -> void:
	_init_threads(8, 0.5, 0.5)
	_term_threads()

func benchmark_8_threads_slope_contention() -> void:
	_init_threads(8, 0.0, 1.0)
	_term_threads()

func benchmark_8_threads_little_contention() -> void:
	_init_threads(8, 0.1, 0.1)
	_term_threads()


func benchmark_12_threads_full_contention() -> void:
	_init_threads(12)
	_term_threads()

func benchmark_12_threads_half_contention() -> void:
	_init_threads(12, 0.5, 0.5)
	_term_threads()

func benchmark_12_threads_slope_contention() -> void:
	_init_threads(12, 0.0, 1.0)
	_term_threads()

func benchmark_12_threads_little_contention() -> void:
	_init_threads(12, 0.1, 0.1)
	_term_threads()
