using Godot;
using System;

public partial class taskmaster : GodotObject
{

	Godot.Collections.Dictionary tasks_by_prereq;
	Godot.Collections.Dictionary tasks_by_category;


	Godot.Collections.Array task_queue;
	
	public bool queue_task() {
		return true;
	}
	
	private bool organize_by_prereq() {
		return true;
	}
	
	private bool organize_by_category() {
		return true;
	}
	
	public bool get_tasks_for_unit() {
		return true;
	}
	
	public void print_task() {
		
	}
	
	private void closest_task() {
		
	}
	
	
}
