extends Syntax
class_name Criteria

var by_parent = false

func fits(unit, target = null):
	pass

func _init(data):
	if data.has("by_parent"):
		by_parent = data.by_parent
