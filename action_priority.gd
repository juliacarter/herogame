extends Object
class_name ActionPriority

var actions = []

func insert_action(action, priority = 0):
	modify_action_prio(action, 0)
	
func modify_action_prio(action, modification):
	var i = actions.find(action)
	if i != -1:
		actions.pop_at(i)
		var new = i + modification
		if new < 0:
			new = 0
		if new > actions.size():
			new = actions.size()
		actions.insert(new, action)
	else:
		actions.insert(modification, action)
	
func organize_priority():
	pass
