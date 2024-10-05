extends Panel

@onready var rules = get_node("/root/WorldVariables")
@onready var grid = get_node("GridContainer")

var buttonscene = load("res://unit_button.tscn")

var selected = []

# Called when the node enters the scene tree for the first time.
func _ready():
	load_selection(rules.selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func select_unit(unit):
	rules.select(unit)

func clear_selection():
	for i in range(selected.size()-1, -1, -1):
		var unit = selected.pop_at(i)
		grid.remove_child(unit)

func load_selection(units):
	clear_selection()
	for key in units:
		var unit = units[key]
		var button = buttonscene.instantiate()
		button.load_unit(unit)
		selected.append(button)
		grid.add_child(button)
