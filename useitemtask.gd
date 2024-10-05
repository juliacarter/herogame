extends Task
class_name UseItemTask

var item
var count
var base

func doable():
	if actor.has_item(base, count):
		return object.can_interact.has(actor.id)
	else:
		return false

func _init(newrole, newtarget, work, newtype, furniture, newitem, newcount):
	super(newrole, newtarget, work, newtype, furniture)
	item = newitem
	base = item.base
	count = newcount
	
func complete():
	job.complete()
	finish()
	actor.consume_item(base, count)
