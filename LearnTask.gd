extends Task
class_name LearnTask

var lesson

func progress(delta):
	if lesson.learn(delta):
		lesson.teach()
		return true
	else:
		return false

func _init(newrole, newtarget, newlesson, furniture):
	desired_role = newrole
	target = newtarget
	fetchtarget = newtarget
	lesson = newlesson
	lesson.task = self
	type = "learn"
	if furniture != null:
		object = furniture
		
func start_job():
	lesson.map.active_lessons.merge({
		lesson.id: lesson
	})
