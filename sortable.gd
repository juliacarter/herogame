extends Object
class_name Sortable

#whether this is a "real" sortable or a table widget
#if false, add a Spacer instead
var sorts = true

#size of the column in a table
var size = 0

var title = ""

var ascending = true

var displayscene = ""

func _init(sortdata = {}):
	if sortdata.has("title"):
		title = sortdata.title
	if sortdata.has("displayscene"):
		displayscene = sortdata.displayscene

func sort(objects):
	var result = objects.duplicate()
	result.sort_custom(sort_func)
	return result

func is_ascending(result):
	if !ascending:
		result = !result
	return result

func sort_func(a, b):
	pass

func sort_ascending(a, b):
	pass
	
func sort_descending(a, b):
	pass
