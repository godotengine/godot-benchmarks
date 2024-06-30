#include "binary_trees.h"
#include <godot_cpp/core/class_db.hpp>

#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void CPPBenchmarkBinaryTrees::_bind_methods() {
    ClassDB::bind_method(D_METHOD("benchmark_binary_trees_13"), &CPPBenchmarkBinaryTrees::benchmark_binary_trees_13);
    ClassDB::bind_method(D_METHOD("benchmark_binary_trees_15"), &CPPBenchmarkBinaryTrees::benchmark_binary_trees_15);
    ClassDB::bind_method(D_METHOD("benchmark_binary_trees_18"), &CPPBenchmarkBinaryTrees::benchmark_binary_trees_18);
}

void CPPBenchmarkBinaryTrees::calculate_binary_trees(int input) {
    int max_depth = godot::Math::max(min_depth + 2, input);

    int stretch_depth = max_depth + 1;
    TreeNode* stretch_tree = TreeNode::create(stretch_depth);
    godot::UtilityFunctions::print("stretch tree of depth ", stretch_depth, "\t check: ", stretch_tree->check());
    delete stretch_tree;

    TreeNode* long_lived_tree = TreeNode::create(max_depth);
    int max_plus_min_depth = max_depth + min_depth;
    for (int depth = min_depth; depth < max_depth; depth += 2) {
        int iterations = 1 << (max_plus_min_depth - depth);
        int check = 0;
        for (int i = 0; i < iterations; i++) {
            TreeNode* check_tree = TreeNode::create(depth);
            check += check_tree->check();
            delete check_tree;
        }

        godot::UtilityFunctions::print(iterations, "\t trees of depth ", depth, "\t check: ", check);
    }

    godot::UtilityFunctions::print("long lived tree of depth ", max_depth, "\t check: ", long_lived_tree->check());
    delete long_lived_tree;
}

void CPPBenchmarkBinaryTrees::benchmark_binary_trees_13() {
	calculate_binary_trees(13);
}

void CPPBenchmarkBinaryTrees::benchmark_binary_trees_15() {
	calculate_binary_trees(15);
}

void CPPBenchmarkBinaryTrees::benchmark_binary_trees_18() {
	calculate_binary_trees(18);
}

CPPBenchmarkBinaryTrees::CPPBenchmarkBinaryTrees() {}

CPPBenchmarkBinaryTrees::~CPPBenchmarkBinaryTrees() {}
