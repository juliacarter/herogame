extends Panel

@onready var rules = get_node("/root/WorldVariables")
@onready var data = get_node("/root/Data")
@onready var grid = get_node("GridContainer")
var buttonscene = load("res://role_button.tscn")

var buttons = []

var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_role(role):
	parent.add_role(role)

func _on_close_pressed():
	visible = false

func clear_roles():
	for button in buttons:
		grid.remove_child(button)
		buttons.erase(buttons.find(button))

func load_roles(roles):
	clear_roles()
	visible = true
	for role in roles:
		var newbutton = buttonscene.instantiate()
		newbutton.parent = self
		newbutton.load_role(role)
		buttons.append(newbutton)
		grid.add_child(newbutton)
