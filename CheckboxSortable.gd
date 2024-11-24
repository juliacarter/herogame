extends Sortable
class_name CheckboxSortable

var radio = false

func _init(sortdata = {}):
	displayscene = "CheckboxSortableControl"
	super(sortdata)
	#sorts = false

func sort_func(a, b):
	var result = a.selected < b.selected
	return is_ascending(result)
