extends Task
class_name TransportTask

var transport

func _init(port, newtrans):
	object = port
	target = port.spots.interact[0].global_position
	transport = newtrans
	personal = true
	reserving = false
	type = "transport"

func doable():
	return object.can_interact.has(actor.id)
	
	
