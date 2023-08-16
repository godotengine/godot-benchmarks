extends Benchmark

const ITERATIONS = 1_000_000
const ENGINE_NAME = "Godot"
const FORMAT_DICT = {engine = ENGINE_NAME}

var engine_name := "Godot"
var some_integer := 123456
var some_float := 1.2
var some_vector2i := Vector2i(12, 34)

# Benchmark various ways to format strings.

func benchmark_no_op_constant_method() -> void:
	for i in ITERATIONS:
		"Hello nothing!".format({})


func benchmark_simple_constant_concatenate() -> void:
	for i in ITERATIONS:
		"Hello " + ENGINE_NAME + "!"


func benchmark_simple_constant_percent() -> void:
	for i in ITERATIONS:
		"Hello %s!" % ENGINE_NAME


func benchmark_simple_constant_method() -> void:
	for i in ITERATIONS:
		"Hello {engine}!".format({engine = ENGINE_NAME})


func benchmark_simple_constant_method_constant_dict() -> void:
	for i in ITERATIONS:
		"Hello {engine}!".format(FORMAT_DICT)


func benchmark_simple_variable_concatenate() -> void:
	for i in ITERATIONS:
		"Hello " + engine_name + "!"


func benchmark_simple_variable_percent() -> void:
	for i in ITERATIONS:
		"Hello %s!" % engine_name


func benchmark_simple_variable_method() -> void:
	for i in ITERATIONS:
		"Hello {engine}!".format({engine = engine_name})


func benchmark_complex_variable_concatenate() -> void:
	for i in ITERATIONS:
		"Hello " + engine_name + "!\nA few examples of formatting: " + str(some_integer) + ", " + str(some_float).pad_decimals(2) + ", " + str(some_vector2i)


func benchmark_complex_variable_percent() -> void:
	for i in ITERATIONS:
		"Hello %s!\nA few examples of formatting: %d, %.2f, %v" % [engine_name, some_integer, some_float, some_vector2i]


func benchmark_complex_variable_method() -> void:
	for i in ITERATIONS:
		"Hello {engine}!\nA few examples of formatting: {an_integer}, {a_float}, {a_vector2}".format({
				engine = engine_name,
				an_integer = some_integer,
				a_float = str(some_float).pad_decimals(2),
				a_vector2i = some_vector2i,
		})
