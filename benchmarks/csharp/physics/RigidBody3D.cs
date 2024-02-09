using System;
using Godot;

// Identical benchmark to "rigid_body_3d.gd" but written in C#

public partial class RigidBody3D : Benchmark
{
    const bool VISUALIZE = true; 
    const double SPREAD_H = 20.0f;
    const double SPREAD_V = 10.0f;

    private WorldBoundaryShape3D boundary_shape = new WorldBoundaryShape3D();
    private BoxShape3D BoxShape = new BoxShape3D();
    private SphereShape3D SphereShape = new SphereShape3D();
    private BoxMesh BoxMesh = new BoxMesh();
    private SphereMesh SphereMesh = new SphereMesh();

    public RigidBody3D()
    {
        test_physics = true;
        test_idle = true;
    }

    public Node3D SetupScene(Func<bool, bool, Godot.RigidBody3D> create_body_func, bool unique_shape, bool ccd_mode, bool boundary, int num_shapes)
    {
        Node3D scene_root = new Node3D();

        if(VISUALIZE)
        {
            Camera3D camera = new Camera3D() { Position = new Vector3(0.0f, 20.0f, 20.0f) };
            camera.RotateX(-0.8f);
            scene_root.AddChild(camera);
        }

        if (boundary)
        {
            StaticBody3D pit = new StaticBody3D();
            pit.AddChild(CreateWall(new Vector3((float)SPREAD_H, 0.0f, 0.0f), new Vector3(0.0f, 0.0f, 0.2f)));
            pit.AddChild(CreateWall(new Vector3(0.0f, 0.0f, (float)SPREAD_H), new Vector3(-0.2f, 0.0f, 0.0f)));
            pit.AddChild(CreateWall(new Vector3(-(float)SPREAD_H, 0.0f, 0.0f), new Vector3(0.0f, 0.0f, -0.2f)));
            pit.AddChild(CreateWall(new Vector3(0.0f, 0.0f, -(float)SPREAD_H), new Vector3(0.2f, 0.0f, 0.0f)));
            scene_root.AddChild(pit);
        }

        for(int i = 0; i < num_shapes; i++)
        {
            Godot.RigidBody3D body = create_body_func(unique_shape, ccd_mode);
            body.Position = new Vector3((float)GD.RandRange(-SPREAD_H, SPREAD_H), (float)GD.RandRange(0.0d, SPREAD_V), (float)GD.RandRange(-SPREAD_H, SPREAD_H));
            scene_root.AddChild(body);
        }

        return scene_root;
    }

    public CollisionShape3D CreateWall(Vector3 position, Vector3 rotation)
    {
        return new CollisionShape3D() {Shape = boundary_shape, Position = position, Rotation = rotation };
    }

    public Godot.RigidBody3D CreateRandomShape(bool unique_shape, bool ccd_mode)
    {
        switch(GD.RandRange(0,1))
        {
            case 0: return CreateBox(unique_shape, ccd_mode);
            default: return CreateSphere(unique_shape, ccd_mode);
        }
    }

    public Godot.RigidBody3D CreateBox(bool unique_shape, bool ccd_mode)
    {
        Godot.RigidBody3D rigid_body = new Godot.RigidBody3D();
        CollisionShape3D collision_shape = new CollisionShape3D();
        rigid_body.ContinuousCd = ccd_mode;

        if(VISUALIZE) { rigid_body.AddChild(new MeshInstance3D(){ Mesh = BoxMesh }); }

        if (unique_shape) { collision_shape.Shape = new BoxShape3D(); }
        else { collision_shape.Shape = BoxShape; }

        rigid_body.AddChild(collision_shape);
        return rigid_body;
    }

    public Godot.RigidBody3D CreateSphere(bool unique_shape, bool ccd_mode)
    {
        Godot.RigidBody3D rigid_body = new Godot.RigidBody3D();
        CollisionShape3D collision_shape = new CollisionShape3D();
        rigid_body.ContinuousCd = ccd_mode;

        if(VISUALIZE) { rigid_body.AddChild(new MeshInstance3D(){ Mesh = SphereMesh }); }

        if (unique_shape) { collision_shape.Shape = new SphereShape3D(); }
        else { collision_shape.Shape = SphereShape; }

        rigid_body.AddChild(collision_shape);
        return rigid_body;
    }

    public Node3D Benchmark2000RigidBody3DSquares()
    {
        return SetupScene(CreateBox, false, false, true, 2000);
    }

    public Node3D Benchmark2000RigidBody3DCircles()
    {
        return SetupScene(CreateSphere, false, false, true, 2000);
    }

    public Node3D Benchmark2000RigidBody3DMixed()
    {
        return SetupScene(CreateRandomShape, false, false, true, 2000);
    }

    public Node3D Benchmark2000RigidBody3DUnique()
    {
        return SetupScene(CreateRandomShape, true, false, true, 2000);
    }

    public Node3D Benchmark2000RigidBody3DContinuous()
    {
        return SetupScene(CreateRandomShape, false, true, true, 2000);
    }

    public Node3D Benchmark2000RigidBody3DUnbound()
    {
        return SetupScene(CreateRandomShape, false, false, false, 2000);
    }
}