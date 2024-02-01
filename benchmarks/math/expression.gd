extends Benchmark

const NUM_EXPRESSIONS := 20
const NUM_VARS := 3000

var rng = RandomNumberGenerator.new()
	
func _var_names():
	var rv = []
	for i in NUM_VARS:
		rv.append("x" + str(i))
	return rv
	
func _var_values():
	var rv = []
	for i in NUM_VARS:
		rv.append((i+1)*10)
	return rv

func _combine(nodes, ia, ib, op):
	var na = nodes[ia]
	var nb = nodes[ib]
	nodes.remove_at(ib)
	nodes.remove_at(ia)
	nodes.append("(" + str(na) + " " + op + " " + str(nb) + ")")

func _generate_string() -> String:
	var nodes = []
	var operators = ["+", "-", "*", "/"]

	nodes.append_array(_var_names())

	while len(nodes) > 1:
		var ia = rng.randi_range(0, len(nodes)-1)
		var ib = rng.randi_range(0, len(nodes)-1)
		var io = rng.randi_range(0, len(operators)-1)
		var op = operators[io]

		if ia == ib:
			ib = ia+1
			if ib == len(nodes):
				ib = 0

		if ia < ib:
			_combine(nodes, ia, ib, op)
		elif ib < ia:
			_combine(nodes, ib, ia, op)

	return nodes[0]

func _generate_strings():
	rng.seed = 234

	var rv = []
	for i in NUM_EXPRESSIONS:
		rv.append(_generate_string())
	return rv

func _parse_all(strs):
	var rv = []
	for s in strs:
		var expr = Expression.new()
		var err = expr.parse(s, _var_names())
		rv.append(expr)
	return rv
	
func _execute_all(exprs):
	var rv = []
	for expr in exprs:
		var r = expr.execute(_var_values())
		rv.append(r)
	return rv

func benchmark_generate_strings():
	var strs = _generate_strings()
	
func benchmark_generate_strings_and_parse():
	var strs = _generate_strings()
	var exprs = _parse_all(strs)
	
func benchmark_generate_strings_and_parse_then_execute():
	var strs = _generate_strings()
	var exprs = _parse_all(strs)
	_execute_all(exprs)
