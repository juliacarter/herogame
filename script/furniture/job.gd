extends Object
class_name Job

var timed = true
var time = 10
var speed = 10

var location

var automatic = false
var repeating = false

var personal = false
var in_place = false

var working = false

var active = false

var repeat = false
var continues = false


var jobbase

var started = false

var done = false

var awaiting_assignment = false

var type

var id

var desiredspot = ""

var taskmaster

var desired_role = "worker"
var neededitems = {}
var found_needs = {}

var task_queue = []
var assignments = []

var certs = {}

var task_exists = false

var waiting_for_resource = false

var template: TaskTemplate


var actorslots = {}
var desiredactors = {}
var foundactors = 0

var doable = true

var tags = []

var rules
var map: Grid

var action
var args = []

var drains = {}
var experience = {}

var skilltrains = {}

var queued = false

var instant = false

var on_start = null

var jobname

var datakey

var healing = {}

var rnr = false

func save():
	var saved_tasks = []
	var saved_assignments = []
	for i in task_queue.size():
		var task = task_queue[i]
		var assignment = assignments[i]
		saved_tasks.append(task.save())
		if assignment == null:
			saved_assignments.append(assignment)
		else:
			saved_assignments.append(assignment.id)
	var save_dict = {
		"jobname": jobname,
		"datakey": datakey,
		"id": id,
		"map": map.id,
		"time": time,
		"tags": tags.duplicate(),
	}
	#if actor != null:
	#	save_dict.merge({
	#		"actor": actor.id
	#	})
	return save_dict

func clear_actors():
	pass

func repush_request():
	foundactors = 0
	#map.active_jobs.erase(id)
	for key in desiredactors:
		for actor in desiredactors[key].actors:
			await actor.delete_task()
		desiredactors[key].actors = []
	if location is Furniture:
		location.unreserve_slots()
	taskmaster.add_task(self)

func workers_ready():
	var result = true
	for slot in desiredactors:
		var workslot = desiredactors[slot]
		var actors = workslot.actors
		if foundactors < actors.size():
			repush_request()
			result = false
			return false
		else:
			pass
		for actor in actors:
			if actor.current_task != null:
				if actor.current_task.job != null:
					if actor.current_task.job != self:
						pass
				else:
					pass
			else:
				pass
			if !actor.working:
				result = false
	return result

func remove_actor(actor):
	for key in desiredactors:
		var i = desiredactors[key].actors.find(actor)
		if type != "restore":
			pass
		if desiredactors[key].actors.size() < desiredactors[key].count && desiredactors[key].count >= 2:
			pass
		if i != -1:
			desiredactors[key].actors.pop_at(i)
		else:
			pass
	
func can_do():
	if(doable):
		if(location.entity() == "FURNITURE"):
			if !location.built:
				var result = true
				for slot in desiredactors:
					var actors = desiredactors[slot].actors
					for actor in actors:
						if !location.can_build.has(actor.id):
							result = false
				return result
			else:
				var result = true
				for slot in desiredactors:
					var actors = desiredactors[slot].actors
					for actor in actors:
						if !location.can_interact.has(actor.id) && actor.stored_in != location:
							result = false
				return result
		elif(location.entity() == "SQUARE"):
			var result = true
			for slot in desiredactors:
				var actors = desiredactors[slot].actors
				for actor in actors:
					if !location.can_interact.has(actor.id):
						result = false
			return result
		elif(location.entity() == "UNIT"):
			var result = true
			for slot in desiredactors:
				var actors = desiredactors[slot].actors
				for actor in actors:
					if !location.can_interact.has(actor.id):
						result = false
			return result
	else:
		return false

func finish_escort(actor):
	actor.drop_task()
	actor.be_dropped()
	#actor.global_position = location.global_position
	make_task_for_unit(actor)
	#assign_actor(actor, "interact")
	#complete()

func check_completion():
	return time > 0


#Progress the job. Returns true if the job has completed, false otherwise
func work(delta):
	if instant:
		time = 0
		return true
	start_work()
	var progress = calc_prog(delta)
	calc_healing(delta, "interact")
	time -= progress
	if jobname == "Mine Ore":
		pass
	var result = check_completion()
	return result
		
func start_work():
	if !started:
		active = true
		
		if on_start != null:
			callv(on_start, args)
		started = true
		
func calc_prog(delta):
	var progress = delta
	for key in desiredactors:
		var slot = desiredactors[key]
		var actors = slot.actors
		var haste = {}
		if slot.modifiers.has("haste"):
			haste = slot.modifiers.haste.duplicate()
		for worker in actors:
			if experience.has(key):
				for potential in experience[key]:
					worker.gain_experience(potential, experience[key][potential])
			progress += worker.work_value(delta, haste)
			worker.apply_drain(drains, delta, haste)
			for skill in skilltrains:
				var amount = skilltrains[skill]
				worker.train_skill(delta, skill, amount)
	return progress
	
func calc_healing(delta, slotname):
	for key in healing:
		var value = healing[key]
		if desiredactors.has(slotname):
			var slot = desiredactors[slotname]
			var actors = slot.actors
			for worker in actors:
				worker.apply_healing(key, value * delta)

func calc_drain(delta):
	pass
		
func reserve(resource, amount):
	pass
	
func get_task(slotname = "interact"):
	var newtask
	newtask = Task.new(desired_role, location.get_global_position(), self, type, location)
	if certs.has(slotname):
		newtask.certs = certs[slotname].duplicate()
	return newtask
	
		
func start_job():
	started = true
	if location == null:
		make_task()
	else:
		location.queue_job(self)
		#make_task()
		
func make_task():
	if !automatic:
		pass
	print("Making Task " + jobname)
	var needs = check_needs()
	
	foundactors = 0
	for key in desiredactors:
		desiredactors[key].actors = []
	if(needs.is_empty() && !automatic):
		map.waiting_jobs.erase(id)
		task_exists = true
		actorslots = {}
		#location.unreserve_slots()
		awaiting_assignment = true
		taskmaster.add_task(self)
		if location.entity() == "FURNITURE":
			location.current_job = self
			location.in_use = true
		return true
	elif needs.is_empty() && automatic:
		found_needs = {}
		if !neededitems.is_empty():
			for base in neededitems.keys():
				var count = neededitems[base]
				if(location.contains(base.id) != null):
					location.remove(base.id, "input", count)
		var next_needs = check_needs()
		get_stuff(next_needs)
		if location.entity() == "FURNITURE":
			location.current_job = self
			location.in_use = true
		if !repeat:
			if on_start != null:
				callv(on_start, args)
		waiting_for_resource = false
		task_exists = true
		map.waiting_jobs.merge({
			id: self
		})
		if automatic:
			map.active_jobs.merge({
				id: self
			})
		return true
	else:
		if !waiting_for_resource:
			return await get_stuff(needs)
		#return false
	
func try_make():
	if can_make():
		make_task()
		
func can_make():
	var result = true
	var needs = check_needs()
	if !needs.is_empty():
		result = false
	if task_exists:
		result = false
	return result
		
func get_stuff(needs):
	for need in needs.keys():
		var has = 0
		#var available = map.count_items_available(need)
		if found_needs.has(need):
			has += found_needs[need]
		var count = needs[need]
		count -= has
		print("=====")
		print("fetching items")
		print(need.itemname)
		print(needs.get(need))
		
		if count > 0:
			var result = await map.taskmaster.make_hauls(need, count, location, "input", false, self)
			if result is int:
				pass
			print(count)
			print(result.found)
			print("-----")
			if result.found == 0:
				return false
				#pass
				#if map.active_depot != null:
				#	map.active_depot.depot_order(need, needs[need], location, "input", false)
			else:
				
				if result.found > 0:
					waiting_for_resource = true
					var found = result.found
					if found_needs.has(need):
						found += found_needs[need]
					found_needs.merge({
						need: found
					}, true)
					pass
				else:
					if map.active_depot != null:
						map.active_depot.depot_order(need, result.needed, location, "input", false)
	
	return true
				
				
func return_task():
	var needs = check_needs()
	print("===")
	print("Make task for")
	print("====")
	found_needs = {}
	foundactors = 0
	for key in desiredactors:
		desiredactors[key].actors = []
	var has = false
	if(needs.is_empty()):
		print("empty needs")
		var newtask = Task.new(desired_role, location.get_square().global_position, self, type, location)
		if certs.has("interact"):
			newtask.certs = certs.interact.duplicate()
		task_exists = true
		if automatic:
			map.active_jobs.merge({
				id: self
			})
		#desiredactors.interact.actors.append(unit)
		newtask.personal = true
		queued = true
		return newtask
	else:
		for need in needs.keys():
			var difference = needs.get(need)
			if difference > 0:
				order_fetch(need, needs.get(need))
				waiting_for_resource = true
			else:
				has = true
	if has:
		var newtask = Task.new(desired_role, location.spots.interact[0].get_global_position(), self, type, location)
		newtask.certs = certs.interact.duplicate()
		actorslots = {}
		#desiredactors.interact.actors.append(unit)
		waiting_for_resource = false
		return newtask
	
	return null
				
func make_escort_for_unit(unit):
	if desiredactors.has("interact"):
		desiredactors.interact.escorted = true
		var task = EscortTask.new(self, unit, location)
		task.personal = true
		task_exists = true
		if automatic:
			map.active_jobs.merge({
				id: self
			})
		taskmaster.add_task(task)
				
func return_task_for_unit(unit):
	var newtask = Task.new(desired_role, location.spots.interact[0].get_global_position(), self, type, location)
	if certs.has("interact"):
		newtask.certs = certs.interact.duplicate()
	actorslots = {}
	#desiredactors.interact.actors.append(unit)
	waiting_for_resource = false
	location.task_queue.push_back(newtask)
	location.assignments.push_back(unit)
	return newtask
				
func make_task_for_unit(unit):
	var needs = check_needs()
	print("===")
	print("Make task for")
	print(unit)
	print("====")
	found_needs = {}
	foundactors = 0
	for key in desiredactors:
		desiredactors[key].actors = []
	var has = false
	if(needs.is_empty()):
		print("Making Task " + jobname)
		if location.entity() == "FURNITURE":
			location.current_job = self
			location.in_use = true
		foundactors = 0
		for key in desiredactors:
			desiredactors[key].actors = []
		if(needs.is_empty() && !automatic):
			var newtask = return_task_for_unit(unit)
			return newtask
	else:
		for need in needs.keys():
			var difference = needs.get(need)
			if difference > 0:
				order_fetch(need, needs.get(need))
				waiting_for_resource = true
			else:
				has = true
	if has:
		var newtask = return_task_for_unit(unit)
		return newtask
			
		
func delete_task():
	map.taskmaster.remove_by_id(id)
	#map.active_jobs.erase(id)
	location.unreserve_slots("interact")
	location.in_use = false
	started = false
	task_exists = false
	#map.active_jobs.erase(id)
	waiting_for_resource = false
	for slot in desiredactors:
		var actors = desiredactors[slot].actors
		for actor in actors:
			if actor != null:
				actor.delete_task()
		
		
func pause():
	if task_exists:
		started = false
		#task_exists = false
		#map.active_jobs.erase(id)
		for slot in desiredactors:
			var actors = desiredactors[slot]
			for actor in actors:
				if actor != null:
					task_queue.append(actor.pause_task())
				else:
					var result = map.taskmaster.remove_by_id(id)
					for task in result:
						task_queue.append(task)

func unpause():
	if task_queue.size() > 0:
		location.pop_task()
		
func satisfied():
	var needs = check_needs()
	var has_needed = true
	for need in needs.keys():
		var difference = needs.get(need)
		if difference > 0:
			has_needed = false
		else:
			has_needed = true
		
#func add_resource(resource, amount):
#	print("Adding " + String.num(amount) + " of " + resource)
#	if neededresources.has(resource):
#		var has = 0
#		if(resources.has(resource)):
#			has = resources.get(resource)
#		resources.merge({resource: (has + amount)}, true)
#		print("added:")
#		print(resources)
#	if(satisfied):
#		z)
		
func check_ready():
	if !task_exists:
		var needs = await check_needs()
		if needs.is_empty():
			await make_task()
		else:
			await get_stuff(needs)
		
func check_needs():
	var differences = {}
	for base in neededitems:
		var need = neededitems.get(base)
		var available = 0
		var shelf = "input"
		if location.shelves[shelf].contents.has(base.id):
			available = location.shelves[shelf].contents[base.id].count
		var difference = need - available
		if difference > 0:
			differences.merge({base: difference}, true)
		pass
	return differences
	
func find_container():
	pass
		
func reset():
	foundactors = 0
	time = speed
		
func complete():
	active = false
	await callv(action, args)
	started = false
	#done = true
	reset()
	if jobbase != null:
		jobbase.waiting = false
	if action != "continue_fueled_power":
		pass
	for key in desiredactors:
		for actor in desiredactors[key].actors:
			await actor.finish_task()
	if !continues:
		for key in desiredactors:
			for i in range(desiredactors[key].actors.size()-1, -1, -1):
				var actor = desiredactors[key].actors[i]
				if(actor != null):
					print("Job complete: " + action + " by: " + actor.nickname)
				desiredactors[key].actors.pop_at(i)
	
	if(location.entity() == "FURNITURE"):
		task_exists = false
		location.job_instances.erase(jobname)
		location.in_use = false
		location.can_pop = true
	if !automatic:
		pass
	foundactors = 0
	
	if map != null:
		map.jobs_completed.merge({
			action: 0
		})
		map.jobs_completed[action] += 1
	
	task_exists = false
	waiting_for_resource = false
	if location is Furniture:
		await location.unreserve_slots("interact")
	
	for item in neededitems:
		var count = neededitems[item]
		location.remove_item(item, count, "input")
	
	location.job_instances.erase(id)
	location.current_job = null
	
	for slot in desiredactors:
		#desiredactors[slot].count = 0
		desiredactors[slot].actors = []
	#await map.active_jobs.erase(id)
	#time = speed
	if repeating:
		repeat = true
		make_task()
	if map.active_jobs.has(id):
		pass

func assign_actor(unit, slot):
	if desiredactors[slot].actors.size() > desiredactors[slot].count:
		return false
	else:
		desiredactors[slot].actors.append(unit)
	if foundactors > 2:
		pass
	return true
	
func placeholder():
	print("placeholder action")
		
#func heal_worker(amount):
	#if(actor != null):
		#print(actor.nickname + " healed")
		#actor.heal_or_hurt(amount)
		
func research_current(amount):
	rules.player.science.progress_research(amount)
		
func perform_research(type, count):
	rules.player.science.progress_research(type, count)
		
func make_tile(tiledata):
	pass
		
func scan_amount(amount):
	rules.opportunity_scan(amount)
		
func make_resource(type, amount):
	await location.create(type, amount, "output", true)
	#print("made " + type.itemname + " " + String.num(amount))
	
func roll_cash(min, max):
	var die = max - min
	var roll = randi() % die
	var amount = roll + min
	rules.player.intangibles.cash += amount
		
func change_resource(resource, amount):
	print(resource)
	print(amount)
	rules.modify_resource(resource, amount)
	
func start_fueled_power(amount):
	map.power += amount
	
func continue_fueled_power(amount):
	if check_needs().is_empty():
		repeat = true
		make_task()
	else:
		repeat = false
		map.power -= amount
		
func start_monitor_camera_network(amount):
	map.camerapower += amount
	
func continue_monitor_camera_network(amount):
	if check_needs().is_empty():
		repeat = true
		make_task()
	else:
		repeat = false
		map.camerapower -= amount

#func take_finished(takenresources):
#	for resource in takenresources:
#		if(contents.has(resource)):
#			contents.merge({resource: contents.get(resource) - takenresources.get(resource)}, true)
#	return takenresources
	
#func store_resource(storedresources):
#	for resource in storedresources:
#		if rules.resources.has(resource):
#			print("has " + resource)
#			rules.resources.merge({
#				resource: rules.resources.get(resource) + storedresources.get(resource)
#			}, true)
#		else:
#			print("no " + resource)
#			rules.resources.merge({
#				resource: storedresources.get(resource, true)
#			}, true)
#	print(rules.resources)

func dig_wall(x, y):
	map.flip_tile(x, y)
	
func fill_wall(x, y):
	map.flip_tile(x, y)
		
func order_fetch(resource, amount):
	pass
#	if(!map.containers.is_empty()):
#		var fetchtask = Task.new((furniture.object_name + "fetch"), furniture.interactspot.get_global_position(), self, "fetch", map, furniture)
#		fetchtask.resource = {resource: amount}
#		var fetchtarget: Furniture
#		fetchtarget = map.containers.values()[0]
#		fetchtask.fetchtarget = fetchtarget
#		fetchtask.target = fetchtarget.interact.get_global_position()
#		rules.jobs.push_back(fetchtask)
#		return true
#	else:
#		return false
		
#func alter_stat(stat, amount):
	#actor.change_stat(stat, amount)
	
#func satisfy_needs(needs, values):
#	for i in needs.size():
#		alter_stat(needs[i], values[i])
#	actor.need_satisfaction()
		
func order_store(resource, amount):
	if(!map.containers.is_empty()):
		var fetchtask = Task.new("hauler", map.containers.values()[0].interactspot.get_global_position(), self, "haul", map.containers.values()[0])
		print("hauling")
		fetchtask.resource = {resource: amount}
		var fetchtarget: Furniture
		fetchtarget = location
		fetchtask.fetchtarget = location
		fetchtask.target = location.interact.get_global_position()
		print(fetchtask.fetchtarget)
		print(fetchtask.object)
		print(fetchtask.target)
		map.taskmaster.add_task(fetchtask)
		return true
	else:
		return false
	
func _init(data, grid):
	jobname = data.jobname
	instant = data.instant
	in_place = data.in_place
	action = data.action
	args = data.args
	skilltrains = data.skilltrains.duplicate()
	continues = data.continues
	healing = data.healing.duplicate()
	certs = data.certs.duplicate()
	for key in data.slots:
		var count = data.slots[key].count
		var role = data.slots[key].role
		var modifiers = {}
		if data.slots[key].has("modifiers"):
			modifiers = data.slots[key].modifiers.duplicate()
		var reserving = true
		if data.slots[key].has("reserving"):
			reserving = data.slots[key].reserving
		var escorted = false
		if data.slots[key].has("escorted"):
			escorted = data.slots[key].escorted
		var slot = WorkSlot.new({"title": key, "count": count, "max": 0, "role": role, "reserving": reserving, "modifiers": modifiers, "escorted": escorted})
		desiredactors.merge({
			key: slot
		})
	datakey = data.key
	rules = data.rules
	speed = data.speed
	time = data.speed
	type = data.type
	personal = data.personal
	drains = data.drains
	experience = data.experience.duplicate()
	automatic = data.automatic
	if data.on_start != null:
		on_start = data.on_start
		
	desired_role = data.desired_role
	
	neededitems = data.requirements
	
	map = grid
	
func spy_on_furniture():
	for actor in desiredactors.interact.actors:
		actor.spy_on(location)
	
func get_food(foodname):
	for actor in desiredactors.interact.actors:
		actor.start_personal_job(foodname, true)
	
func attach_furniture(target):
	print(target)
	print(target.map)
	location = target
	map = location.map
	
func attach_square(target):
	location = target
	
func add_map(newmap):
	map = newmap
	
func attach_rules(newrules):
	rules = newrules
	
func build_furniture():
	location.construct()

func imprison_actor(slotname):
	if desiredactors.has(slotname):
		var slots = desiredactors[slotname].actors
		for actor in slots:
			location.store_unit(actor)
	
func get_certified(potential, slotname):
	var result = {}
	for key in potential:
		var unit = potential[key]
		if is_certified(unit, slotname):
			result.merge({
				unit.id: unit
			})
	return result
		
func is_certified(unit, slot):
	if certs == {}:
		return true
	var result = true
	for cert in certs[slot]:
		if !unit.modifiers.has(cert):
			result = false
	return result
			
func get_in_bed():
	for actor in desiredactors.interact.actors:
		location.store_unit(actor)
		actor.asleep = true
		actor.start_personal_job("sleep", true, location)
		
func exfiltrate_actors():
	for actor in desiredactors.interact.actors:
		actor.exfiltrate()
		
func finish_sleeping():
	for actor in desiredactors.interact.actors:
		#var square = location.get_square()
		#actor.global_position = square.global_position
		actor.asleep = false
