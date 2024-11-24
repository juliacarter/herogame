extends Object
class_name Taskmaster

var rules

var tasks_by_prereq = {}
var tasks_by_category = {}

var tasks = []


var active_tasks = {}

var map

var assigning = false

var idle_units = {}
var needs_haul = {}

var job_requests = []
var haul_requests = []

func save():
	var saved_tasks = []
	var saved_hauls = []
	for request in haul_requests:
		saved_hauls.append(request.save())
	for task in tasks:
		saved_tasks.append(task.save())
	var save_dict = {
		"map": map.id,
		"tasks": saved_tasks,
		"haul_requests": saved_hauls,
	}
	return save_dict
	
func load_save(savedata):
	for taskdata in savedata.tasks:
		if taskdata.type == "interact":
			var task = Task.new(savedata.desired_role, null, null, savedata.type, null)
			task.target = rules.ids[savedata.target]
			task.job = rules.ids[savedata.job]
			task.object = rules.ids[savedata.object]
			tasks.append(task)
	for requestdata in savedata.haul_requests:
		var request = HaulRequest.new(null, requestdata.count, null, null, requestdata.final, null)
		request.stack = rules.ids[requestdata.stack]
		request.destination = rules.ids[requestdata.destination]
		request.shelf = rules.ids[requestdata.shelf]
		request.job = rules.ids[requestdata.job]
		haul_requests.append(request)
	return self

func sort_by_category():
	tasks_by_category = {}
	for task in tasks:
		tasks_by_category.merge({
			task.category: tasks_by_category[task.category].append(task)
		}, true)
		
func get_closest_task(unit, possible):
	var closest_distance = 100000
	var closest = null
	for task in possible:
		var distance = task.target.distance_to(unit.position)
		if distance < closest_distance:
			closest = task
			closest_distance = distance
	return tasks.pop_at(tasks.find(closest))
	
func assign_hauls():
	for key in needs_haul:
		var stack = needs_haul[key]
		store_task(stack, stack.count)
		needs_haul.erase(key)
	
func assign_patrols():
	var patrolprio = map.patrols_by_priority
	var units = idle_units.duplicate()
	
	if units != {}:
		for priority in patrolprio:
			var queue = PriorityQueue.new()
			for patrol in patrolprio[priority]:
				queue.insert(patrol, patrol.has)
			var next = []
			while !queue.empty():
				var patrol = queue.extract()
				if patrol.has < patrol.desired:
					var sorted = map.sort_units_by_role(units)
					if sorted.has("guard"):
						var desired = sorted.guard.duplicate()
						var closest = await map.unittree.closest(patrol.nodes[0].global_position, desired, false)
						if closest.object != null:
							idle_units.erase(closest.object.id)
							units.erase(closest.object.id)
							closest.object.start_patrol(patrol)
							next.append(patrol)
				if next != []:
					for i in next.size():
						var new = next.pop_at(i)
						queue.insert(new, new.has)
		
	
func assign_closest_units():
	assigning = true
	if job_requests != []:
		var checking_units = idle_units.duplicate()
		for request in job_requests:
			var job = request.job
			var served = false
			var queued = {}
			job.foundactors = 0
			for key in request.slots:
				var found = false
				if key == "serve":
					if job.location.get_spot_actors("serve") != []:
						found = true
						served = true
				var slot = job.desiredactors[key]
				var ready = true
				for unitkey in request.units:
					request.job.foundactors += 1
					var unit = request.units[unitkey]
					queued.merge({
						"interact": []
					})
					queued.interact.append(unit.unit)
				#job.desiredactors[key].actors = []
				var sorted = map.sort_units_by_role(checking_units)
				if sorted.has(slot.role):
					var desired = job.get_certified(sorted[slot.role], slot.title)
					
					while !found:
						var closest = await map.unittree.closest(job.location.global_position, desired, false).object
						if closest != null:
							if request.job.foundactors >= slot.count:
								found = true
								break
							checking_units.erase(closest.id)
							desired.erase(closest.id)
							queued.merge({
								key: []
							})
							request.job.foundactors += 1
							queued[key].append(closest)
							
						else:
							found = true
						pass
			var done = true
			for key in request.slots:
				if !(key == "serve" && served):
					if !queued.has(key):
						done = false
					else:
						if queued[key].size() < request.slots[key].count:
							done = false
						if queued[key].size() > 2:
							pass
			if done:
				for key in job.desiredactors:
					pass
					#job.desiredactors[key].actors = []
				job_requests.pop_at(job_requests.find(request))
				for key in queued:
					var slot = request.slots[key]
					for unit in queued[key]:
						var task
						if !slot.escorted:
							task = request.job.get_task()
							unit.queue.push_back(task)
							idle_units.erase(unit.id)
							active_tasks.merge({
								task.id: task
							})
						else:
							task = EscortTask.new(request.job, unit, request.job.location)
							task.job = request.job
							tasks.append(task)
						task.reserving = slot.reserving
						task.for_request = true
						
						#task.update_actor(unit)
						
						
						#job.actorslots[key].append(unit)
				map.active_jobs.merge({
					request.job.id: request.job
				})
			else:
				request.job.foundactors = 0
				
	for task in tasks:
		var sorted = map.sort_units_by_role(idle_units)
		if sorted.has(task.desired_role):
			var desired = task.get_certified(sorted[task.desired_role])
			if task is EscortTask:
				desired.erase(task.client.id)
			var closest = await map.unittree.closest(task.target, desired, false).object
			if closest != null:
				active_tasks.merge({
					task.id: task
				})
				if task.job != null:
					task.job.foundactors += 1
				#task.update_actor(closest)
				if !task is GrabTask:
					pass
				closest.queue.push_back(tasks.pop_at(tasks.find(task)))
				idle_units.erase(closest.id)
			if task.job is Job:
				map.active_jobs.merge({
					task.job.id: task.job
				})
	for request in haul_requests:
		var sorted = map.sort_units_by_role(idle_units)
		if sorted.has("hauler"):
			var desired = sorted.hauler
			if request.count == 0:
				pass
			if idle_units == {}:
				break
			else:
				var targets = {}
				for key in desired:
					var unit = desired[key]
					if unit.free_weight - unit.future_weight > 0 && unit.idle:
						targets.merge({
							unit.id: unit
						})
				if targets != {}:
					if request.stack != null:
						var closest = await map.unittree.closest(request.stack.location.position, targets, false).object
						if closest != null:
							var hauled = 0
							var available = closest.free_weight - closest.future_weight
							if available < request.count:
								hauled = available
							else:
								hauled = request.count
							var task = GrabTask.new("hauler", request.stack.location.position, "fetch", request.stack.location, request.stack, hauled)
							task.shelf = request.shelf
							task.set_haul(request.destination.position, request.destination, request.stack, "storage", request.final)
							closest.future_weight += hauled
							idle_units.erase(closest.id)
							closest.queue.push_front(task)
							request.count -= hauled
							pass
							if request.stack.reserved_count > request.stack.count:
								pass
					else:
						request.count = 0
	for i in range(haul_requests.size() - 1, -1, -1):
		var request = haul_requests[i]
		if request.count <= 0:
			haul_requests.pop_at(i)
	assigning = false

func depot_order(base, count):
	var depot = map.active_depot

func make_hauls(base, count, location, shelf, final, job):
	var result = await haul_task(base, count, location, shelf, final, job)
	if result == null:
		return {"needed": count, "found": 0}
	if result.needed <= 0:
		return {"needed": result.needed, "found": result.found}
	if result.needed > 0:
		var next = await make_hauls(base, result.needed, location, shelf, final, job)
		return {"needed": next.needed, "found": next.found + result.found}
	else:
		return 0
			
func haul_task(base, count, location, shelf, final, job):
	var item = await map.find_item_amount_for(base, count, location)
	if item == null:
		return {"needed": 0, "found": 0}
	item.job = job
	#item.reserved = true
	var found = 0
	var available = item.count - item.reserved_count
	if available <= 0:
		return null
	var hauled = 0
	if count < available:
		item.reserved_count += count
		hauled = count
	else:
		item.reserved_count += available
		hauled = available
	if item.location.entity() == "UNIT":
		return {"needed": 0, "found": 0}
	if hauled <= 0:
		return {"needed": 0, "found": 0}
	if shelf == "output":
		pass
	var request = HaulRequest.new(item, hauled, location, shelf, final, job)
	haul_requests.append(request)
	var result = count - hauled
	return {"needed": result, "found": hauled}
	#var found = count
	#for i in count:
	#	if i < item.count:
	#		found -= 1
	#		var fetchtask = GrabTask.new("hauler", item.location.position, "fetch", location, item)
	#		fetchtask.set_haul(location.position, {"item": item, "count": 1, "base": item.base}, shelf, final)
	#		fetchtask.fetchtarget = item.location
	#		tasks.push_back(fetchtask)
	#return found
	
func store_task(item, count):
	var container = map.find_container_for(item, item.count)
	if container != null:
		item.reserved = true
		item.reserved_count += count
		if item.reserved_count > item.count:
			pass
		var request = HaulRequest.new(item, count, container, item.shelf.name, true, null)
		haul_requests.append(request)
	#for i in count:
	#	if container != null:
	#		if item.location.entity() == "UNIT":
	#			return
	#		var storetask = GrabTask.new("hauler", item.location.position, "fetch", container, item)
	#		storetask.set_haul(container.position, {"item": item, "count": 1, "base": item.base}, "storage", true)
	#		storetask.fetchtarget = item.location
	#		tasks.push_back(storetask)
			
func targeted_haul(item, count, container, shelf, final):
	var request = HaulRequest.new(item, count, container, shelf, final, null)
	haul_requests.append(request)
	#item.reserved = true
	#for i in count:
	#	if container != null:
	#		if item.location.entity() == "UNIT":
	#			return
	#		var storetask = GrabTask.new("hauler", item.location.position, "fetch", container, item)
	#		storetask.set_haul(container.position, {"item": item, "count": 1, "base": item.base}, shelf, true)
	#		storetask.fetchtarget = item.location
	#		tasks.push_back(storetask)
	
	
func remove_by_id(id):
	var result = []
	for i in range(tasks.size()-1, -1, -1):
		var task = tasks[i]
		if task.id == id:
			result.append(tasks.pop_at(i))
	return result
	
func add_task(job, assigned = []):
	if job is Job:
		var has = false
		for request in job_requests:
			if request.job == job:
				has = true
		if !has:
			var request = JobRequest.new(job)
			for unit in assigned:
				request.assign_unit(unit)
			job_requests.append(request)
	else:
		job.taskmaster = self
		tasks.append(job)

func has_task():
	return tasks.size() > 0
