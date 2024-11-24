extends SortableDisplay

@onready var rules = get_node("/root/WorldVariables")

@onready var button = get_node("Button")

func display():
	button.text = sortable.get_display(object)


func _on_button_pressed() -> void:
	rules.open_view_for(object)
