extends BaseEffect
#OneShots are Effects that are added once, have an effect, and then are never removed
class_name OneShotEffect

var function = ""
var args = []

func _init(data):
	type = "oneshot"
	if data.has("function"):
		function = data.function
	if data.has("args"):
		args = data.args.duplicate
	oneshot = true
	
func apply_effect(unit, count):
	var newargs = args.duplicate()
	newargs.push_front(count)
	unit.callv(function, newargs)
