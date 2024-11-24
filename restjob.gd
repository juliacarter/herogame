extends Job
#a job that runs until the Actor no longer meets damage & value thresholds for the stats it restores
class_name RestJob

func work(delta):
	start_work()
	var progress = calc_prog(delta)
	calc_healing(delta, "interact")
	var result = check_completion()
	if result:
		complete()
	
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
