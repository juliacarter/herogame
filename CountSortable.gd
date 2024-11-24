extends NumericSortable
class_name CountSortable

func _init(sortdata = {}):
	super(sortdata)
	title = "count"
	
func get_value(object):
	return object.count
