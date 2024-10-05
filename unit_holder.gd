extends Control

@onready var namelabel = get_node("Name")
@onready var squadoption = get_node("SquadOption")
@onready var classoption = get_node("ClassOption")
@onready var rules = get_node("/root/WorldVariables")

var unit

func set_unit(newunit):
	for i in range(squadoption.item_count - 1, -1, -1):
		squadoption.remove_item(i)
	unit = newunit
	namelabel.text = unit.firstname + " " + unit.lastname
	for squadname in rules.squads:
		squadoption.add_item(squadname)
	for classname in rules.classes:
		classoption.add_item(classname)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
