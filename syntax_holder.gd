extends HBoxContainer
class_name SyntaxHolder

@onready var synbutton = get_node("Button")

var syntax_type = "criteria"

var syntax: Syntax
var slots = []

var screen

var deleted = false

var saved = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func save_syntax():
	if deleted:
		#syntax.remove()
		return false
	for slot in slots:
		slot.save_value()
	return true
	
func load_syntax(newsyn):
	syntax = newsyn
	syntax_type = syntax.type
	synbutton.text = newsyn.name()
	var buttons = syntax.buttons()
	for button in buttons:
		button.screen = screen
		slots.append(button)
		add_child(button)


func _on_button_pressed() -> void:
	deleted = true
	visible = false
