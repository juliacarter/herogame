extends Power
class_name ActionPower

var action

func fire():
	var target = rules.hovered
	if target is Unit:
		action.fire_at(target)

func _init(data, newrules):
	super(data, newrules)
	if data.has("action"):
		action = data.action

func altclick():
	action.autocast = !action.autocast
