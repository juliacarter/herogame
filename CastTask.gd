extends Task
class_name CastTask

var action

#whether the unit wants to move to a cast point, or simply stay in place
var wants_move = false

func _init(newabil, newobj):
	object = newobj
	target = object.global_position
	action = newabil
	during_combat = true
	type = "cast"

func doable():
	if !wants_move:
		return true
	if object.global_position.distance_squared_to(actor.global_position) <= (action.range * action.range):
		return true
	else:
		return false
