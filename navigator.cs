using Godot;
using System;
using System.Collections.Generic;

public partial class navigator : Object
{
    GDScript cell = GD.Load<GDScript>("res://navcell.gd");

    public Array Astar(GDScript origin, GDScript destination, bool breaking)
	{
		
		GDScript link = GD.Load<GDScript>("res://link.gd");
        GDScript square = GD.Load<GDScript>("res://script/world/square.gd");
        PriorityQueue<GDScript, int> heap = new PriorityQueue<GDScript, int>();
		return null;
	}
}
