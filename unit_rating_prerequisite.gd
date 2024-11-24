extends UnitPrerequisite
class_name UnitRatingPrerequisite

var rating = ""

var count = 0

func _init(prereqdata):
	if prereqdata.has("count"):
		count = prereqdata.count
	if prereqdata.has("rating"):
		rating = prereqdata.rating

func check_against(unit):
	if unit.ratings.has(rating):
		var available = unit.ratings[rating].value
		if available >= count:
			return true
	return false
