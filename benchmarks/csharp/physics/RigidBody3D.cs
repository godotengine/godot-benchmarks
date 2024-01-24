using System;
using Godot;

// Identical benchmark to "rigid_body_3d.gd" but written in C#

public partial class RigidBody3D : Benchmark
{
    const bool VISUALIZE = true; 

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

    public Node3D SetupScene(Func<bool, Godot.RigidBody3D> create_body_func, bool unique_shape, int num_shapes)
    {
        Node3D scene_root = new Node3D();

        if(VISUALIZE)
        {
            Camera3D camera = new Camera3D() { Position = new Vector3(0.0f, 20.0f, 20.0f) };
            camera.RotateX(-0.8f);
            scene_root.AddChild(camera);
        }

        StaticBody3D pit = new StaticBody3D();
        pit.AddChild(CreateWall(new Vector3(10.0f, 0.0f, 0.0f), new Vector3(0.0f, 0.0f, 0.4f)));
        pit.AddChild(CreateWall(new Vector3(0.0f, 0.0f, 10.0f), new Vector3(-0.4f, 0.0f, 0.0f)));
        pit.AddChild(CreateWall(new Vector3(-10.0f, 0.0f, 0.0f), new Vector3(0.0f, 0.0f, -0.4f)));
        pit.AddChild(CreateWall(new Vector3(0.0f, 0.0f, -10.0f), new Vector3(0.4f, 0.0f, 0.0f)));
        scene_root.AddChild(pit);

        for(int i = 0; i < num_shapes; i++)
        {
            Godot.RigidBody3D box = create_body_func(unique_shape);
            box.Position = new Vector3((float)GD.RandRange(-10.0d, 10.0d), (float)GD.RandRange(-10.0d, 10.0d), 10.0f);
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

    public Node3D Benchmark1000RigidBody3DSharedBoxShape()
    {
        return SetupScene(CreateBox, false, 1000);
    }

    public Node3D Benchmark1000RigidBody3DUniqueBoxShape()
    {
        return SetupScene(CreateBox, true, 1000);
    }

    public Node3D Benchmark1000RigidBody3DSharedSphereShape()
    {
        return SetupScene(CreateSphere, false, 1000);
    }

    public Node3D Benchmark1000RigidBody3DUniqueSphereShape()
    {
        return SetupScene(CreateSphere, true, 1000);
    }
}