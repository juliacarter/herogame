extends Job
class_name ResearchJob

func make_task():
	if rules.science.current_tech != null:
		print("Making Task")
		var needs = check_needs()
		if(needs.is_empty() && !automatic):
			if !neededitems.is_empty():
				for base in neededitems.keys():
					var count = neededitems[base]
					if(location.contains(base.id) != null):
						location.remove(base.id, "input", count)
			waiting_for_resource = false
			task_exists = true
			print("Doesnt Need Anything")
			var newtask = Task.new(desired_role, location.spots[0].get_global_position(), self, type, location)
			print(newtask.target)
			task_queue.append(newtask)
			assignments.append(null)
			queued = true
			print(self)
			print(rules.jobs)
			return true
		elif needs.is_empty() && automatic:
			if !neededitems.is_empty():
				for base in neededitems.keys():
					var count = neededitems[base]
					if(location.contains(base.id) != null):
						location.remove(base.id, "input", count)
			var next_needs = check_needs()
			get_stuff(next_needs)
			if !repeat:
				if on_start != null:
					callv(on_start, args)
			waiting_for_resource = false
			task_exists = true
			return false
		else:
			get_stuff(needs)
			return false
