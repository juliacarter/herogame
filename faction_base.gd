extends Object
class_name FactionBase

var unitlists = {}

var waves = {}
var wave_weights = {}

var name

var color

var alignment = "hero"

var type = "agency"

func _init(data):
	if data.has("name"):
		name = data.name
