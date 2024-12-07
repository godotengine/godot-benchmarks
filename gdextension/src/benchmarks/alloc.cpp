#include "alloc.h"

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/random_number_generator.hpp>
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void CPPBenchmarkAlloc::_bind_methods() {
	ClassDB::bind_method(D_METHOD("benchmark_deep_tree"), &CPPBenchmarkAlloc::benchmark_deep_tree);
	ClassDB::bind_method(D_METHOD("benchmark_wide_tree"), &CPPBenchmarkAlloc::benchmark_wide_tree);
	ClassDB::bind_method(D_METHOD("benchmark_fragmentation"), &CPPBenchmarkAlloc::benchmark_fragmentation);
	ClassDB::bind_method(D_METHOD("benchmark_duplicate"), &CPPBenchmarkAlloc::benchmark_duplicate);
}

void CPPBenchmarkAlloc::benchmark_deep_tree() {
	Node *rt = memnew(Node);
	for (int i = 0; i < iterations; i++) {
		Node *n = memnew(Node);
		n->add_child(rt);
		rt = n;
	}
	// Avoid triggering a stack overflow with memdelete(rt)
	while (rt->get_child_count() != 0) {
		Node *n = rt->get_child(0);
		rt->remove_child(n);
		memdelete(rt);
		rt = n;
	}
	memdelete(rt);
}

void CPPBenchmarkAlloc::benchmark_wide_tree() {
	Node *rt = memnew(Node);
	for (int i = 0; i < iterations; i++) {
		rt->add_child(memnew(Node));
	}
	memdelete(rt);
}

void CPPBenchmarkAlloc::benchmark_fragmentation() {
	Node *top = memnew(Node);
	for (int i = 0; i < 5; i++) {
		top->add_child(memnew(Node));
	}
	Ref<RandomNumberGenerator> rand;
	rand.instantiate();
	for (int k = 0; k < 10; k++) {
		for (int i = 0; i < iterations; i++) {
			// Attempt to scatter children in memory by assigning newly created nodes to a random parent
			int idx = rand->randi() % top->get_child_count();
			top->get_child(idx)->add_child(memnew(Node));
		}

		Node *tmp = top->get_child(0);
		top->remove_child(tmp);
		// Since nodes in the tree are scattered in memory,
		// freeing subtrees this way should maximize fragmentation.
		memdelete(tmp);
		top->add_child(memnew(Node));
	}

	memdelete(top);
}

void CPPBenchmarkAlloc::benchmark_duplicate() {
	Node *rt = memnew(Node);
	for (int i = 0; i < 16; i++) {
		Node *n = memnew(Node);
		n->add_child(rt->duplicate());
		n->add_child(rt->duplicate());
		memdelete(rt);
		rt = n;
	}
	memdelete(rt);
}

CPPBenchmarkAlloc::CPPBenchmarkAlloc() {}

CPPBenchmarkAlloc::~CPPBenchmarkAlloc() {}
