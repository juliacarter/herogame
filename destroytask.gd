extends Task
class_name DestroyTask



func doable():
	if actor.seen_furniture.has(object.id):
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
	type = "destroy"
