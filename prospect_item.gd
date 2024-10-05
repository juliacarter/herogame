extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var label = get_node("HBoxContainer/Label")

var prospect = ""

func load_prospect(new):
	prospect = new
	label.text = prospect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	rules.hire_prospect(prospect)
