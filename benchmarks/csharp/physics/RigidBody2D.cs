using System;
using Godot;

// Identical benchmark to "rigid_body_2d.gd" but written in C#

public partial class RigidBody2D : Benchmark
{
    const bool VISUALIZE = true; 
    const double SPREAD_H = 1600.0f;
    const double SPREAD_V = 800.0f;

    private WorldBoundaryShape2D boundary_shape = new WorldBoundaryShape2D();
    private RectangleShape2D SquareShape = new RectangleShape2D();
    private CircleShape2D CircleShape = new CircleShape2D();
    private QuadMesh SquareMesh = new QuadMesh();
    private SphereMesh CircleMesh = new SphereMesh();

    public RigidBody2D()
    {
        SquareMesh.Size = new Vector2(20.0f, 20.0f);
        CircleMesh.Radius = 10.0f;
        CircleMesh.Height = 20.0f;
        benchmark_time = 10e6;
        test_physics = true;
        test_idle = true;
    }

    public Node2D SetupScene(Func<bool, Godot.RigidBody2D.CcdMode, Godot.RigidBody2D> create_body_func, bool unique_shape, Godot.RigidBody2D.CcdMode ccd_mode, bool boundary, int num_shapes)
    {
        Node2D scene_root = new Node2D();

        if(VISUALIZE)
        {
            Camera2D camera = new Camera2D() { Position = new Vector2(0.0f, -100.0f), Zoom = new Vector2(0.5f, 0.5f) };
            scene_root.AddChild(camera);
        }

        if (boundary)
        {
            StaticBody2D pit = new StaticBody2D();
            pit.AddChild(CreateWall(new Vector2((float)SPREAD_H, 0.0f), -0.1f));
            pit.AddChild(CreateWall(new Vector2(-(float)SPREAD_H, 0.0f), 0.1f));
            scene_root.AddChild(pit);
        }

        for(int i = 0; i < num_shapes; i++)
        {
            Godot.RigidBody2D body = create_body_func(unique_shape, ccd_mode);
            body.Position = new Vector2((float)GD.RandRange(-SPREAD_H, SPREAD_H), (float)GD.RandRange(0.0d, -SPREAD_V));
            scene_root.AddChild(body);
        }

        return scene_root;
    }

    public CollisionShape2D CreateWall(Vector2 position, float rotation)
    {
        return new CollisionShape2D() {Shape = boundary_shape, Position = position, Rotation = rotation };
    }

    public Godot.RigidBody2D CreateRandomShape(bool unique_shape, Godot.RigidBody2D.CcdMode ccd_mode)
    {
        switch(GD.RandRange(0,1))
        {
            case 0: return CreateSquare(unique_shape, ccd_mode);
            default: return CreateCircle(unique_shape, ccd_mode);
        }
    }

    public Godot.RigidBody2D CreateSquare(bool unique_shape, Godot.RigidBody2D.CcdMode ccd_mode)
    {
        Godot.RigidBody2D rigid_body = new Godot.RigidBody2D();
        CollisionShape2D collision_shape = new CollisionShape2D();
        rigid_body.ContinuousCd = ccd_mode;

        if(VISUALIZE) { rigid_body.AddChild(new MeshInstance2D(){ Mesh = SquareMesh }); }

        if (unique_shape) { collision_shape.Shape = new RectangleShape2D(); }
        else { collision_shape.Shape = SquareShape; }

        rigid_body.AddChild(collision_shape);
        return rigid_body;
    }

    public Godot.RigidBody2D CreateCircle(bool unique_shape, Godot.RigidBody2D.CcdMode ccd_mode)
    {
        Godot.RigidBody2D rigid_body = new Godot.RigidBody2D();
        CollisionShape2D collision_shape = new CollisionShape2D();
        rigid_body.ContinuousCd = ccd_mode;

        if(VISUALIZE) { rigid_body.AddChild(new MeshInstance2D(){ Mesh = CircleMesh }); }

        if (unique_shape) { collision_shape.Shape = new CircleShape2D(); }
        else { collision_shape.Shape = CircleShape; }

        rigid_body.AddChild(collision_shape);
        return rigid_body;
    }

    public Node2D Benchmark2000RigidBody2DSquares()
    {
        return SetupScene(CreateSquare, false, Godot.RigidBody2D.CcdMode.Disabled, true, 2000);
    }

    public Node2D Benchmark2000RigidBody2DCircles()
    {
        return SetupScene(CreateCircle, false, Godot.RigidBody2D.CcdMode.Disabled, true, 2000);
    }

    public Node2D Benchmark2000RigidBody2DMixed()
    {
        return SetupScene(CreateRandomShape, false, Godot.RigidBody2D.CcdMode.Disabled, true, 2000);
    }

    public Node2D Benchmark2000RigidBody2DUnique()
    {
        return SetupScene(CreateRandomShape, true, Godot.RigidBody2D.CcdMode.Disabled, true, 2000);
    }

    public Node2D Benchmark2000RigidBody2DContinuous()
    {
        return SetupScene(CreateRandomShape, false, Godot.RigidBody2D.CcdMode.CastShape, true, 2000);
    }

    public Node2D Benchmark2000RigidBody2DUnbound()
    {
        return SetupScene(CreateRandomShape, false, Godot.RigidBody2D.CcdMode.Disabled, false, 2000);
    }
}
