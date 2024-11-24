extends StringSortable
class_name NameSortable

func _init(sortdata = {}):
	super(sortdata)
	title = "name"

func get_value(from):
	return from.object_name("short")
