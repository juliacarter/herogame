extends Object
class_name Impact

var origin

var type = ""

var key = ""

var magnitude = 0

#tags used by the Impact, mostly for triggers and such
var tags = []

func get_text():
	return "unimplemented impact"

func _init(impactdata, newori = null):
	if impactdata.has("key"):
		key = impactdata.key
	if impactdata.has("type"):
		type = impactdata.type
	if impactdata.has("magnitude"):
		magnitude = impactdata.magnitude
	origin = newori

func fire(target, crits = 0, flat_bonus = 0, percent_bonus = 0):
	pass
