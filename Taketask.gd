extends GrabTask
class_name TakeTask


func _init(content, newtarget, newtype, furniture, newitem, newshelf):
	super(content, newtarget, newtype, furniture, newitem, 1)
	shelf = newshelf

func doable():
	return object.can_interact.has(actor.id)
