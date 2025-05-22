extends Panel

@onready var grid = get_node("ScrollContainer/GridContainer")

var buttonscene = load("res://scene/interface/tool_button.tscn")

var buttons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_palette(options):
	for button in options:
		var newbutton = buttonscene.instantiate()
		newbutton.make_button(button.tool_data)
		buttons.append(newbutton)
		grid.add_child(newbutton)
