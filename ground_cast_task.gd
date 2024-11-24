extends CastTask
class_name GroundCastTask

func _init(newabil, newpos):
	type = "cast"
	action = newabil
	wants_move = action.move_to
	target = newpos

func doable():
	if !wants_move:
		return true
	if target.distance_squared_to(actor.global_position) <= (action.range * action.range):
		return true
	else:
		return false
