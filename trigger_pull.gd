extends Object
class_name TriggerPull

var trigger
var target

func _init(new, by) -> void:
	trigger = new
	target = by
	
func fire():
	var outcomes = trigger.outcomes
	for outcome in outcomes:
		outcome.fire(target)
