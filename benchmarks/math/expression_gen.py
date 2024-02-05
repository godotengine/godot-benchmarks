#!/usr/bin/env python3
import json
import random

NUM_EXPRESSIONS = 20
NUM_VARS = 3000  # Should be kept in sync with NUM_VARS in expression.gd

def _var_names():
	rv = []
	for i in range(NUM_VARS):
		rv.append("x" + str(i))
	return rv

def _var_values():
	rv = []
	for i in range (NUM_VARS):
		rv.append((i+1)*10)
	return rv

def _combine(nodes, ia, ib, op):
	na = nodes[ia]
	nb = nodes[ib]
	del nodes[ib]
	del nodes[ia]
	nodes.append("(" + str(na) + " " + op + " " + str(nb) + ")")

def _generate_string():
	nodes = []
	operators = ["+", "-", "*", "/"]

	nodes += _var_names()

	while len(nodes) > 1:
		ia = random.randrange(0, len(nodes))
		ib = random.randrange(0, len(nodes))
		io = random.randrange(0, len(operators))
		op = operators[io]

		if ia == ib:
			ib = ia+1
			if ib == len(nodes):
				ib = 0

		if ia < ib:
			_combine(nodes, ia, ib, op)
		elif ib < ia:
			_combine(nodes, ib, ia, op)

	return nodes[0]

def _generate_strings():
	random.seed(234)
	rv = []
	for i in range(NUM_EXPRESSIONS):
		rv.append(_generate_string())
	return rv


strings = _generate_strings()
print("const EXPRESSIONS = ", json.dumps(strings, indent=4).replace('    ', '\t'))
