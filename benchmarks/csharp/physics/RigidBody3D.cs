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

    public Node3D SetupScene(Func<bool, Godot.RigidBody3D> create_body_func, bool unique_shape, bool boundary, int num_shapes)
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
            Godot.RigidBody3D box = create_body_func(unique_shape);
            box.Position = new Vector3((float)GD.RandRange(-SPREAD_H, SPREAD_H), (float)GD.RandRange(0.0d, SPREAD_V), (float)GD.RandRange(-SPREAD_H, SPREAD_H));
            scene_root.AddChild(box);
        }

        return scene_root;
    }

    public CollisionShape3D CreateWall(Vector3 position, Vector3 rotation)
    {
        return new CollisionShape3D() {Shape = boundary_shape, Position = position, Rotation = rotation };
    }

    public Godot.RigidBody3D CreateBox(bool unique_shape)
    {
        Godot.RigidBody3D rigid_body = new Godot.RigidBody3D();
        CollisionShape3D collision_shape = new CollisionShape3D();

        if(VISUALIZE) { rigid_body.AddChild(new MeshInstance3D(){ Mesh = BoxMesh }); }

        if (unique_shape) { collision_shape.Shape = new BoxShape3D(); }
        else { collision_shape.Shape = BoxShape; }

        rigid_body.AddChild(collision_shape);
        return rigid_body;
    }

    public Godot.RigidBody3D CreateSphere(bool unique_shape)
    {
        Godot.RigidBody3D rigid_body = new Godot.RigidBody3D();
        CollisionShape3D collision_shape = new CollisionShape3D();

        if(VISUALIZE) { rigid_body.AddChild(new MeshInstance3D(){ Mesh = SphereMesh }); }

        if (unique_shape) { collision_shape.Shape = new SphereShape3D(); }
        else { collision_shape.Shape = SphereShape; }

        rigid_body.AddChild(collision_shape);
        return rigid_body;
    }

    public Node3D Benchmark2000RigidBody3DSharedBoxShape()
    {
        return SetupScene(CreateBox, false, true, 2000);
    }

    public Node3D Benchmark2000RigidBody3DUniqueBoxShape()
    {
        return SetupScene(CreateBox, true, true, 2000);
    }

    public Node3D Benchmark2000RigidBody3DSharedSphereShape()
    {
        return SetupScene(CreateSphere, false, true, 2000);
    }

    public Node3D Benchmark2000RigidBody3DUniqueSphereShape()
    {
        return SetupScene(CreateSphere, true, true, 2000);
    }
}