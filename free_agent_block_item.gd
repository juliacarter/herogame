extends Control
class_name FreeAgentBlockItem

@onready var rules = get_node("/root/WorldVariables")

@onready var label = get_node("HBoxContainer/Label")

var agent
var unit

var block

func load_unit(new):
	agent = new
	unit = agent.unit
	label.text = unit.name()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	rules.hire_agent(agent)
	block.load_free_agents()
