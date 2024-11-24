extends SortableDisplay
class_name TextSortableDisplay

@onready var label = get_node("Label")

func display():
	label.text = sortable.get_display(object)
