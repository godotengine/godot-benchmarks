using System;
using Godot;

// Identical benchmark to "rigid_body_3d.gd" but written in C#

public partial class RigidBody3D : Benchmark
{
    public BoxShape3D BoxShape = new BoxShape3D();
    public SphereShape3D SphereShape = new SphereShape3D();

    public RigidBody3D()
    {
        test_physics = true;
        test_idle = true;
    }

    public Node3D SetupScene(Func<bool, Godot.RigidBody3D> create_body_func, bool unique_shape, int num_shapes)
    {
        Node3D scene_root = new Node3D();
        Camera3D camera = new Camera3D() { Position = new Vector3(1.0f, 0.3f, 0.0f) };
        camera.RotateX(-0.8f);
        scene_root.AddChild(camera);

        for(int i = 0; i < num_shapes; i++)
        {
            Godot.RigidBody3D box = create_body_func(unique_shape);
            box.Position = new Vector3((float)GD.RandRange(-50.0d, 50.0d), (float)GD.RandRange(-50.0d, 50.0d), 0.0f);
            scene_root.AddChild(box);
        }

        return scene_root;
    }

    public Godot.RigidBody3D CreateBox(bool unique_shape)
    {
        Godot.RigidBody3D rigid_body = new Godot.RigidBody3D();
        CollisionShape3D collision_shape = new CollisionShape3D();

        if (unique_shape) { collision_shape.Shape = new BoxShape3D(); }
        else { collision_shape.Shape = BoxShape; }

        rigid_body.AddChild(collision_shape);
        return rigid_body;
    }

    public Godot.RigidBody3D CreateSphere(bool unique_shape)
    {
        Godot.RigidBody3D rigid_body = new Godot.RigidBody3D();
        CollisionShape3D collision_shape = new CollisionShape3D();

        if (unique_shape) { collision_shape.Shape = new SphereShape3D(); }
        else { collision_shape.Shape = SphereShape; }

        rigid_body.AddChild(collision_shape);
        return rigid_body;
    }

    public Node3D Benchmark7500RigidBody3DSharedBoxShape()
    {
        return SetupScene(CreateBox, false, 7500);
    }

    public Node3D Benchmark7500RigidBody3DUniqueBoxShape()
    {
        return SetupScene(CreateBox, true, 7500);
    }

    public Node3D Benchmark7500RigidBody3DSharedSphereShape()
    {
        return SetupScene(CreateSphere, false, 7500);
    }

    public Node3D Benchmark7500RigidBody3DUniqueSphereShape()
    {
        return SetupScene(CreateSphere, true, 7500);
    }
}