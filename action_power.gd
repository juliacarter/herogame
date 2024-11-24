extends Power
class_name ActionPower

var action

func _init(data):
	super(data)
	if data.has("action"):
		action = data.action

func altclick():
	action.autocast = !action.autocast
