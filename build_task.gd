extends Task
class_name BuildTask

func doable():
	return object.can_build.has(actor.id)
