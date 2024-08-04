#ifndef CPP_BENCHMARK_MERKLE_TREES_H
#define CPP_BENCHMARK_MERKLE_TREES_H

#include "../cppbenchmark.h"

namespace godot {
    class CPPBenchmarkMerkleTrees : public CPPBenchmark {
        GDCLASS(CPPBenchmarkMerkleTrees, CPPBenchmark)

        private:
            class TreeNode {
                private:
                    int value;
                    TreeNode* left;
                    TreeNode* right;
                public:
                    TreeNode() {
                        value = -1;
                        left = nullptr;
                        right = nullptr;
                        hash = -1;
                    };
                    TreeNode(int p_value, TreeNode* p_left, TreeNode* p_right) {
                        value = p_value;
                        left = p_left;
                        right = p_right;
                        hash = -1;
                    };
                    ~TreeNode() {
                        delete left;
                        delete right;
                    };
                    bool check() {
                        if (hash != -1) {
                            if (value != -1) {
                                return true;
                            }
                            if (left != nullptr && right != nullptr) {
                                return left->check() && right->check();
                            }
                        }
                        return false;
                    };
                    void cal_hash() {
                        if (hash == -1) {
                            if (value != -1) {
                                hash = value;
                            }
                            else if (left != nullptr && right != nullptr) {
                                left->cal_hash();
                                right->cal_hash();
                                hash = left->hash + right->hash;
                            }
                        }
                    };
                    int hash;
            };

            const int min_depth = 4;
            TreeNode* make_tree(int depth);
            void calculate_merkle_trees(int input);
        protected:
	        static void _bind_methods();
        public:
            void benchmark_merkle_trees_13();
            void benchmark_merkle_trees_15();
            void benchmark_merkle_trees_18();
            CPPBenchmarkMerkleTrees();
            ~CPPBenchmarkMerkleTrees();
    };
}
#endif
