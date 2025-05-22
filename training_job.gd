extends Job
#provides large amounts of Experience until the unit reaches the job's Max Level
#units at or above job level cannot use it for training
class_name TrainingJob

#units can only use this job to train up to this level
var max_level = 0

func _init(data, grid):
	super(data, grid)
	max_level = data.max_level

func work(delta):
	super(delta)

func check_completion():
	if desiredactors.interact.actors != []:
		var done = true
		for key in desiredactors:
			var slot = desiredactors[key]
			for worker in slot.actors:
				for statname in healing:
					if worker.all_stats[statname].damage > 0 || worker.all_stats[statname].value < worker.all_stats[statname].max:
						done = false
		return done
	else:
		return false
