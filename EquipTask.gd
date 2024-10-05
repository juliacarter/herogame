extends GrabTask
class_name EquipTask

var slot

func _init(content, newtarget, newtype, furniture, newitem, newslot):
	super(content, newtarget, newtype, furniture, newitem, 1)
	slot = newslot

func doable():
	return object.can_interact.has(actor.id)
