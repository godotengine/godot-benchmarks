#ifndef CPP_BENCHMARK_BINARY_TREES_H
#define CPP_BENCHMARK_BINARY_TREES_H

#include "../cppbenchmark.h"

namespace godot {
    class CPPBenchmarkBinaryTrees : public CPPBenchmark {
        GDCLASS(CPPBenchmarkBinaryTrees, CPPBenchmark)

        private:
            class TreeNode {
                private:
                    TreeNode* left;
                    TreeNode* right;
                public:
                    TreeNode() {
                        left = nullptr;
                        right = nullptr;
                    };
                    TreeNode(TreeNode* p_left, TreeNode* p_right) {
                        left = p_left;
                        right = p_right;
                    };
                    ~TreeNode() {
                        delete left;
                        delete right;
                    };
                    static TreeNode* create(int d){
                        if (d == 0) 
                            return new TreeNode();
                        return new TreeNode(create(d - 1), create(d - 1));
                    };
                    int check() {
                        int c = 1;
                        if (right != nullptr)
                        {
                            c += right->check();
                        }
                        if (left != nullptr)
                        {
                            c += left->check();
                        }
                        return c;
                    };
            };

            const int min_depth = 4;
            void calculate_binary_trees(int input);
        protected:
	        static void _bind_methods();
        public:
            void benchmark_binary_trees_13();
            void benchmark_binary_trees_15();
            void benchmark_binary_trees_18();
            CPPBenchmarkBinaryTrees();
            ~CPPBenchmarkBinaryTrees();
    };
}
#endif
