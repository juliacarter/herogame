extends NumericSortable
class_name LevelSortable


func get_value(object):
	return object.level


func _init(sortdata = {}):
	#displayscene = "TextSortableDisplay"
	super(sortdata)
	
	title = "level"

