extends Object
class_name JobRequest

var job
var slots = {}

#Units directly assigned to the job by make_task_for_unit
var units = {}

func _init(newjob):
	job = newjob
	slots = job.desiredactors
	
func assign_unit(unit):
	units.merge(
		{
			unit.id:
			{
				"slot": "interact",
				"unit": unit
			}
		}
	)
