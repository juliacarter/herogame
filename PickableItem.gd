extends Control

signal item_picked(item)
signal item_checked(item, value)

var item

@onready var button = get_node("Button")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_item(new):
	item = new
	var newtext = item.callv("object_name", ["short"])
	if newtext != null:
		button.text = newtext

func pick():
	item_picked.emit(item)
	
func check(value):
	item_checked.emit(item, value)

func _on_button_pressed() -> void:
	pick()
	


func _on_check_box_toggled(toggled_on: bool) -> void:
	check(toggled_on)
