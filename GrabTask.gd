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
	base = item.base.id
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
		
func set_haul(newtarget, newobject, newitem, shelf, final):
	resource = newitem
	next_action = GrabTask.new(text, newtarget, "delivery", newobject, item, count)
	next_action.resource = newitem
	next_action.haulshelf = shelf
	next_action.haulfinal = final
	
func grab_item():
	return object.take_from(base, count, shelf)
