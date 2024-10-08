extends UnitPrerequisite
class_name UnitPointPrerequisite

var point = ""

var count = 0

func _init(prereqdata):
	if prereqdata.has("count"):
		count = prereqdata.count
	if prereqdata.has("point"):
		point = prereqdata.point

func check_against(unit):
	if unit.points.has(point):
		var available = unit.points[point]
		if available >= count:
			return true
	return false
