using Godot;

public partial class BinaryTrees : Benchmark
{
    // Based on https://github.com/hanabi1224/Programming-Language-Benchmarks/blob/main/bench/algorithm/binarytrees/1.cs
    class TreeNode
    {
        public TreeNode left;
        public TreeNode right;

        TreeNode(TreeNode left = null, TreeNode right = null)
        {
            this.left = left;
            this.right = right;
        }

        internal static TreeNode Create(int d)
        {
            return d == 0 ? new TreeNode()
                          : new TreeNode(Create(d - 1), Create(d - 1));
        }

        internal int Check()
        {
            int c = 1;
            if (right != null)
            {
                c += right.Check();
            }
            if (left != null)
            {
                c += left.Check();
            }
            return c;
        }
    }

    const int MinDepth = 4;
    public void CalculateBinaryTrees(int input)
    {
        int maxDepth = Mathf.Max(MinDepth + 2, input);

        int stretchDepth = maxDepth + 1;
        GD.Print($"stretch tree of depth {stretchDepth}\t check: {TreeNode.Create(stretchDepth).Check()}");

        TreeNode longLivedTree = TreeNode.Create(maxDepth);
        int maxPlusMinDepth = maxDepth + MinDepth;
        for (int depth = MinDepth; depth < maxDepth; depth += 2)
        {
            int iterations = 1 << (maxPlusMinDepth - depth);
            int check = 0;
            for (int i = 0; i < iterations; i++)
            {
                check += TreeNode.Create(depth).Check();
            }

            GD.Print($"{iterations}\t trees of depth {depth}\t check: {check}");
        }

        GD.Print($"long lived tree of depth {maxDepth}\t check: {longLivedTree.Check()}");
    }

    public void BenchmarkBinaryTrees13()
    {
        CalculateBinaryTrees(13);
    }

    public void BenchmarkBinaryTrees15()
    {
        CalculateBinaryTrees(15);
    }

    public void BenchmarkBinaryTrees18()
    {
        CalculateBinaryTrees(18);
    }
}
