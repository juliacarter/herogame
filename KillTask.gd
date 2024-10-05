extends Task
class_name KillTask

func doable():
	if actor.seen.has(object.id) || object.dead:
		return true
	else:
		return false

func _init(objective):
	object = objective
	target = objective.position
	job = null
	personal = true
	reserving = false
	desired_role = "soldier"
	type = "kill"
	during_combat = true
