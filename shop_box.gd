extends Control
class_name ShopBox

@onready var label = get_node("Label")
@onready var box = get_node("SpinBox")

var entry

var desired = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_item(newentry):
	label.text = newentry.name
	entry = newentry



func _on_spin_box_value_changed(value: float) -> void:
	desired = value


func _on_buy_button_pressed() -> void:
	entry.buy_count(desired)
