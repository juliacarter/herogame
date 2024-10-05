extends Task
class_name ServiceTask

#For ServiceTasks, units will go to the Job's spot and stay there until the unit gets tired or is assigned a higher priority task
#The JobBase's can_serve function checks to see if service slots are filled
#When the associated service job is made, the unit in this task will be assigned to the slot
#When assigning tasks, idle units are assigned before serving units

var base

func _init(newrole, newtarget, work, newtype, furniture, newbase):
	super(newrole, newtarget, work, newtype, furniture)
	jobslot = "serve"
	type = "service"
