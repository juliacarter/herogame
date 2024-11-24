extends NumericSortable
class_name StatSortable

var statname = ""

func _init(sortdata = {}):
	super(sortdata)
	title = "stat"
	if sortdata.has("statname"):
		statname = sortdata.statname
		title = statname

func get_value(object):
	if object.all_stats.has(statname):
		return object.all_stats[statname].value
	else:
		return 0
