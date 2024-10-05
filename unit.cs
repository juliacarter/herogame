using Godot;
using System;

public partial class unit : Area2D
{
	public const float Speed = 300.0f;
	public const float JumpVelocity = -400.0f;
    public Vector2 Velocity = new Vector2();

	// Get the gravity from the project settings to be synced with RigidBody nodes.
	public float gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();

	public void move(double delta)
	{
        Vector2 velocity = Velocity;

       


    }

	public override void _PhysicsProcess(double delta)
	{
        move(delta);
	}
}
