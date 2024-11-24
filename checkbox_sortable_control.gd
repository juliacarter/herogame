extends SortableDisplay
class_name CheckboxSortableControl

@onready var checkbox = get_node("CheckBox")

func _ready():
	selector = true

func set_pressed(value):
	checkbox.button_pressed = value


func _on_check_box_pressed() -> void:
	pass # Replace with function body.


func _on_check_box_toggled(toggled_on: bool) -> void:
	if !sortable.radio:
		parent.toggle(toggled_on)
	else:
		parent.select()
