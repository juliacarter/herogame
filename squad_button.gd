extends Button

@onready var rules = get_node("/root/WorldVariables")

var squad

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func load_squad(newsquad):
	squad = newsquad
	if squad != null:
		text = squad.id
	else:
		text = "n/a"

func load_blank():
	squad = null
	text = "+"


func _on_pressed():
	if squad == null:
		rules.selection_to_squad()
	else:
		rules.select_squad(squad)


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if squad == null:
			rules.make_selection_squad()
		else:
			if event.button_index == 1:
				rules.select_squad(squad)
			elif event.button_index == 2:
				rules.add_selection_to_squad(squad)
