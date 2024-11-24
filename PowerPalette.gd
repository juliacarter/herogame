extends Panel

@onready var rules = get_node("/root/WorldVariables")
@onready var data = get_node("/root/Data")

@onready var grid = get_node("Control/GridContainer")

@onready var digbutton = get_node("DigFill")

var buttonscene = load("res://scene/interface/tool_button.tscn")

var buttons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	digbutton.make_button(data.powers.digfill.tool_data)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func clear_palette():
	for i in range(buttons.size()-1, -1, -1):
		var button = buttons.pop_at(i)
		grid.remove_child(button)

func load_build():
	clear_palette()
	var sortedfurn = {}
	for furniture in data.furniture_palette():
		print(furniture.category)
		sortedfurn.merge({furniture.category: []})
		if(sortedfurn.has(furniture.category)):
			sortedfurn.get(furniture.category).push_back(furniture)
		print(sortedfurn)
	var nextpos = 0
	for cat in data.tool_categories():
		var catbutton = buttonscene.instantiate()
		catbutton.make_button(cat)
		buttons.append(catbutton)
		if sortedfurn.has(cat.name):
			cat.category.tools = []
			for furn in sortedfurn[cat.name]:
				cat.category.tools.append(furn)
		grid.add_child(catbutton)
		
func load_powers():
	clear_palette()
	var sortedpow = {}
	for key in data.powers:
		var power = data.powers[key]
		sortedpow.merge({power.category: []})
		if sortedpow.has(power.category):
			sortedpow[power.category].push_back(power)
	for cat in data.power_categories():
		var catbutton = buttonscene.instantiate()
		catbutton.make_button(cat)
		buttons.append(catbutton)
		if sortedpow.has(cat.name):
			cat.category.tools = []
			for pow in sortedpow[cat.name]:
				cat.category.tools.append(pow)
		grid.add_child(catbutton)

func load_palette(options):
	clear_palette()
	for button in options:
		var newbutton = buttonscene.instantiate()
		var tooldata = button.tool_data
		newbutton.make_button(tooldata)
		buttons.append(newbutton)
		grid.add_child(newbutton)





func _on_dig_button_pressed() -> void:
	pass # Replace with function body.
