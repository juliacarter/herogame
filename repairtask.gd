extends Task
class_name RepairTask

func _init(furn):
	object = furn
	target = furn.position
	job = null
	desired_role = "builder"
	type = "build"
	
func progress(delta):
	if object.repair(delta, actor):
		return true
	else:
		return false
