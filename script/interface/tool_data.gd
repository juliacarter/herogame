extends Object
class_name ToolData

var name
var action
var args
var category

var icon = "sampleicon"

var power

func _init(data):
	name = data.name
	action = data.action
	args = data.args
	category = data.cat
	if data.has("power"):
		power = data.power
