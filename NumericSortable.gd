extends Sortable
#generic sortable for any number, use the get_value function to retrieve the desired value
class_name NumericSortable

func sort_func(a, b):
	var result = get_value(a.object) < get_value(b.object)
	return is_ascending(result)
	
func get_value(from):
	pass
	
func _init(sortdata = {}):
	displayscene = "TextSortableDisplay"
	super(sortdata)
	
	title = "number"

func get_display(object):
	return String.num(get_value(object))
