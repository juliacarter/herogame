extends Task
class_name GrabTask

var item
var count
var base

var shelf



func _init(newrole, newtarget, newtype, furniture, newitem, newcount):
	desired_role = newrole
	target = newtarget
	fetchtarget = newtarget
	type = newtype
	item = newitem
	base = item.base
	reserving = false
	count = newcount
	if furniture != null:
		object = furniture
	else:
		object = job.location
	if(type == "store"):
		print("Hauling for")
		print(target)
		print(job)
		next_action = GrabTask.new(text, target, "delivery", object, item, count)
	item.add_haul_task(self)
		
func set_haul(newtarget, newobject, newitem, shelf, final):
	resource = newitem
	next_action = GrabTask.new(text, newtarget, "delivery", newobject, item, count)
	next_action.resource = newitem
	next_action.haulshelf = shelf
	next_action.haulfinal = final
	
func get_movement():
	if object != null:
		var square = get_square(actor, false)
		return square.global_position
	else:
		return target
	
func get_item():
	return item
	
func task_complete():
	item.remove_haul_task(self)
	
func grab_item():
	return object.take_from(base, count, shelf)
