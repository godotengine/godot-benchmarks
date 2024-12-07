#include "merkle_trees.h"

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void CPPBenchmarkMerkleTrees::_bind_methods() {
	ClassDB::bind_method(D_METHOD("benchmark_merkle_trees_13"), &CPPBenchmarkMerkleTrees::benchmark_merkle_trees_13);
	ClassDB::bind_method(D_METHOD("benchmark_merkle_trees_15"), &CPPBenchmarkMerkleTrees::benchmark_merkle_trees_15);
	ClassDB::bind_method(D_METHOD("benchmark_merkle_trees_18"), &CPPBenchmarkMerkleTrees::benchmark_merkle_trees_18);
}

CPPBenchmarkMerkleTrees::TreeNode *CPPBenchmarkMerkleTrees::make_tree(int depth) {
	if (depth > 0) {
		depth -= 1;
		return new TreeNode(-1, make_tree(depth), make_tree(depth));
	}
	return new TreeNode(1, nullptr, nullptr);
}

void CPPBenchmarkMerkleTrees::calculate_merkle_trees(int input) {
	int max_depth = Math::max(min_depth + 2, input);

	int stretch_depth = max_depth + 1;
	TreeNode *stretch_tree = make_tree(stretch_depth);
	stretch_tree->cal_hash();
	UtilityFunctions::print("stretch tree of depth ", stretch_depth, "\t root hash: ", stretch_tree->hash, "\t check: ", stretch_tree->check());
	delete stretch_tree;

	TreeNode *long_lived_tree = make_tree(max_depth);
	int max_plus_min_depth = max_depth + min_depth;
	for (int depth = min_depth; depth < max_depth; depth += 2) {
		int iterations = 1 << (max_plus_min_depth - depth);
		int sum = 0;
		for (int i = 0; i < iterations; i++) {
			TreeNode *tree = make_tree(depth);
			tree->cal_hash();
			sum += tree->hash;
			delete tree;
		}

		UtilityFunctions::print(iterations, "\t trees of depth ", depth, "\t root hash sum: ", sum);
	}
	long_lived_tree->cal_hash();
	UtilityFunctions::print("long lived tree of depth ", input, "\t root hash: ", long_lived_tree->hash, "\t check: ", long_lived_tree->check());
	delete long_lived_tree;
}

void CPPBenchmarkMerkleTrees::benchmark_merkle_trees_13() {
	calculate_merkle_trees(13);
}

void CPPBenchmarkMerkleTrees::benchmark_merkle_trees_15() {
	calculate_merkle_trees(15);
}

void CPPBenchmarkMerkleTrees::benchmark_merkle_trees_18() {
	calculate_merkle_trees(18);
}

CPPBenchmarkMerkleTrees::CPPBenchmarkMerkleTrees() {}

CPPBenchmarkMerkleTrees::~CPPBenchmarkMerkleTrees() {}
