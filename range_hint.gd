extends Hint
#unit will use the RangeHint with the lowest value to determine its preferred distance
class_name RangeHint

var range = 0

func _init(data):
	if data.has("range"):
		range = data.range
