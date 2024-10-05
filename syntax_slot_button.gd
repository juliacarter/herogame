extends Control
class_name SyntaxSlotButton

@onready var button = get_node("Button")

var syntax
var slot

var screen

var value

var holder

var multi = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if value != null:
		if !value is Array:
			button.text = value.name()
		else:
			if value == []:
				button.text = slot + "empty"
			else:
				var newtext = ""
				for piece in value:
					newtext += piece.name() + "/"
				button.text = newtext
	else:
		button.text = slot


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func save_value():
	syntax.set(slot, value)

func load_syntax(newsyntax, newslot):
	syntax = newsyntax
	slot = newslot
	value = syntax.get(slot)

func pick_item(item, picking_slot):
	value = item
	var newtext = ""
	if !item is Array:
		newtext = value.name()
	else:
		for piece in item:
			newtext += piece.name() + "/"
	button.text = newtext

func _on_pressed() -> void:
	screen.open_picker(self, slot, multi)


func _on_button_pressed() -> void:
	screen.open_picker(self, slot, multi)
