extends Object
class_name BuffBase

var name

var duration = 0
var effects = {}

var stacking = true

var timed = true

var tipname = ""

func apply(unit):
	pass

func _init(data):
	if data.has("name"):
		name = data.name
	if data.has("duration"):
		duration = data.duration
	if data.has("stacking"):
		stacking = data.stacking
	if data.has("tooltip"):
		tipname = data.tooltip
		
func tick(delta, unit):
	pass
