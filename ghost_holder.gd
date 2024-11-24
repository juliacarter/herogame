extends Node2D

@onready var ghostholder = get_node("Ghosts")

var ghostscene = load("res://ghost.tscn")

var ghost

var anchor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if anchor != null:
		#ghost.set_origin(anchor.global_position)

func follow_mouse():
	var pos = get_global_mouse_position()
	position_ghost(pos)

func position_ghost(pos):
	#ghost.position = pot
	if ghost != null:
		if anchor != null:
			ghost.set_origin(anchor.global_position)
		ghost.update_position(pos)

func make_ghosts(someghosts):
	clear_ghosts()
	for ghostdata in someghosts:
		#if ghostscenes.has(ghostdata.type):
		make_ghost(ghostdata)
	return 
		
func make_ghost(ghostdata, origin = null):
	clear_ghosts()
	var newghost = ghostscene.instantiate()
	ghost = newghost
	add_child(ghost)
	#ghosts.append(ghost)
	ghost.load_ghost(ghostdata)
	anchor = origin
	#ghost.set_origin(origin)
	return ghost
	
func clear_ghosts():
	#for i in range(ghosts.size()-1,-1,-1):
		#var ghost = ghosts[i]
		#ghosts.pop_at(i)
	remove_child(ghost)
