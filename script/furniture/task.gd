extends Object
class_name Task

var id

var taskmaster

var fronts = {}
var backs = {}
var indexes ={}

var simple_back: Task

var personal = false
#Drop this task if the unit gets a new task in queue
var fragile = false

var queue: Multiqueue

var text
var type

var certs = []

var for_request = false

var category = "generic"
var desired_role

var target: Vector2
var object
var fetchtarget
var actor: Unit
var tags: Array
var haulshelf
var haulfinal

var workslot

var stoppable = true

var during_combat = false

var jobslot = "interact"

var reserving = true

var done = false


var resource

var job: Job
var next_action: Task

#The speed at which the unit moves to the task
var speed = "run"

func get_certified(units):
	var result = {}
	for key in units:
		var certed = true
		var unit = units[key]
		for cert in certs:
			if !unit.modifiers.has(cert):
				certed = false
		if certed:
			result.merge({
				unit.id: unit
			})
	return result

func start_job():
	if job != null:
		job.map.active_jobs.merge({
			job.id: job
		})

func get_interaction(origin = null, reserving = true, spotname = "interact"):
	pass

func get_square(origin = null, reserving = true, spotname = "interact"):
	var result = object.get_square(origin, reserving, spotname)
	return result

func doable():
	if type == "idle":
		return actor.nav.is_navigation_finished()
	if type == "build":
		return object.can_build.has(actor.id)
	else:
		if job != null:
			return job.can_do()
		else:
			return object.can_interact.has(actor.id)
	return false
		
func update_actor(unit):
	actor = unit
	if(job != null):
		#job.desiredactors[jobslot].actors.append(unit)
		await job.assign_actor(unit, "interact")
		#job.actorslots[jobslot].append(actor)
	print(actor)
		
func grab_item():
	return object.take_from(resource.base.id, resource.count)

	
func deliver_resource(resources):
	for resource in resources.keys():
		job.add_resource(resource, resources.get(resource))

func set_front(tag, task):
	if(task != null):
		print("setting front of " + text + "for " + tag + " as " + task.text)
	else:
		print("setting front of " + text + "for " + tag + " as null")
	fronts[tag] = task
	
func get_target():
	return target
	
func finish():
	if object.map.taskmaster.active_tasks.has(id):
		object.map.taskmaster.active_tasks.erase(id)
	
func progress(delta):
	if job.work(delta):
		return true
	else:
		return false
	
func complete():
	job.complete()
	finish()
	
func pause():
	pass
	
func fetch(resource, amount):
	pass

func deliver(resource, amount):
	pass
	
func set_back(tag, task):
	print("setting back of " + text + " for " + tag + " as " + task.text)
	backs[tag] = task
	
func set_simple_back(task):
	simple_back = task
	
func get_simple_back():
	return simple_back
	
func get_previous(tag):
	return backs[tag]
	
func get_next(tag):
	return fronts[tag]
	
func set_index (tag, index):
	indexes[tag] = index

func _init(newrole, newtarget, work, newtype, furniture, newslot = null):
	desired_role = newrole
	target = newtarget
	fetchtarget = newtarget
	job = work
	workslot = newslot
	type = newtype
	if furniture != null:
		object = furniture
	else:
		if job != null:
			object = job.location
	if(type == "store"):
		print("Hauling for")
		print(target)
		print(job)
		next_action = Task.new(text, target, job, "delivery", object)


func get_queue(tag):
		var result = text
		if(backs.has(tag) && backs[tag] != null):
			result = text + " * " + backs[tag].get_queue(tag)
		return result
		
		
		
func save():
	var save_dict = {
		"target": {"x": target.x, "y": target.y},
		"job": job.id,
		"type": type,
		"desired_role": desired_role,
		"object": object.id,
		"personal": personal,
		"tags": tags.duplicate(),
	}
	if actor != null:
		save_dict.merge({
			"actor": actor.id
		})
	if haulshelf != null:
		save_dict.merge({
			"haulshelf": haulshelf
		})
	return save_dict

func remove_actor(newactor):
	if job != null:
		job.remove_actor(newactor)
	actor = null
