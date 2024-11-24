extends GrabTask
class_name EquipTask

func _init(content, newtarget, newtype, furniture, newitem):
	super(content, newtarget, newtype, furniture, newitem, 1)

func doable():
	return object.can_interact.has(actor.id)
