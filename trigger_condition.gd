extends Criteria
class_name TestCondition

var checkfunc = ""
var by_parent = false

func _init(data):
	if data.has("by_parent"):
		by_parent = data.by_parent
	
func fits(trigger_by, trigger_for = null):
	var result = true
	return result
