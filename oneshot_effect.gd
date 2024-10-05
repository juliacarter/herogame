extends BaseEffect
class_name OneShotEffect

var function = ""
var args = []

func _init(data):
	type = "oneshot"
	if data.has("function"):
		function = data.function
	if data.has("args"):
		args = data.args.duplicate
