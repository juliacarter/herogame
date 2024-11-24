extends Condition
class_name TagCondition

var tag = ""

func fits(trigger_by, trigger_for = null):
	#var needed = desired * desired
	var i = trigger_by.tags.find(tag)
	return i != -1
