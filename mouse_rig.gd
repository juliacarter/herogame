extends Control

@onready var label = get_node("Label")

var tooltip

@onready var ghostholder = get_node("Ghosts")

var ghostscene = load("res://ghost.tscn")

var ghostscenes = {}

var tooltiptext = ""

#active indicators attached to the rig
var ghosts = []

func attach_tooltip(newtip):
	tooltip = newtip
	tooltip.change_position(position)
	tooltip.parent = self
	
func detach_tooltip():
	tooltip = null

func make_ghosts(someghosts):
	clear_ghosts()
	for ghostdata in someghosts:
		#if ghostscenes.has(ghostdata.type):
		make_ghost(ghostdata)
		
func make_ghost(ghostdata, origin = null):
	clear_ghosts()
	var ghost = ghostscene.instantiate()
	ghostholder.add_child(ghost)
	ghosts.append(ghost)
	ghost.load_ghost(ghostdata)
	ghost.set_origin(origin)
	
func clear_ghosts():
	for i in range(ghosts.size()-1,-1,-1):
		var ghost = ghosts[i]
		ghosts.pop_at(i)
		ghostholder.remove_child(ghost)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	if tooltip != null:
		tooltip.change_position(global_position)

func set_tooltip(new):
	tooltiptext = new
	
	tooltip.open_tooltip(tooltiptext)
	return tooltip
	#label.visible = true
	
func clear_tooltip():
	tooltiptext = ""
	tooltip.clear_tooltip()
	return tooltip
	#label.visible = false
