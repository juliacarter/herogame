extends BaseEffect
class_name ActionEffect

#the name of the action to add to the unit
var action = ""

func _init(data):
	super(data)
	if data.has("action"):
		action = data.action

#grant [count] copies if the action to this unit
func apply_effect(unit, count):
	for i in count:
		unit.add_action_by_name(action, 1)
	
#remove [count] copies from the unit
func remove_effect(unit, count):
	for i in count:
		unit.remove_action_by_name(action)
