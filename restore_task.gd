extends Task
class_name RestoreTask

var desired_fill = {}


func progress(delta):
	if actor.needs.is_empty():
		actor.delete_task()
		finish()
		return true
	else:
		return false
