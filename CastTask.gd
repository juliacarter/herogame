extends Task
class_name CastTask

var ability

func _init(newabil, newobj):
	object = newobj
	target = object.global_position
	ability = newabil
	during_combat = true
	type = "cast"

func doable():
	if object.global_position.distance_squared_to(actor.global_position) <= (ability.base.range * ability.base.range):
		return true
	else:
		return false
