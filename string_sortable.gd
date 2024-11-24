extends Sortable
class_name StringSortable


func sort_func(a, b):
	var comp = get_value(a.object).casecmp_to(get_value(b.object))
	var result = (comp == -1)
	return is_ascending(result)

func get_value(from):
	pass

func _init(sortdata = {}):
	displayscene = "TextSortableDisplay"
	super(sortdata)
	
	title = "string"

func get_display(object):
	return get_value(object)
