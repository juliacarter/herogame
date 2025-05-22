extends StringSortable
class_name ClassNameSortable

func get_value(from):
	if from.unit_class != null:
		return from.unit_class.classname
	else:
		return "noclass"

func _init(sortdata = {}) -> void:
	super(sortdata)
	title = "class"
