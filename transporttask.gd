extends Task
class_name TransportTask

var transport

var destination

func _init(port, newtrans):
	object = port
	target = port.spots.interact[0].global_position
	transport = newtrans
	#destination = newdest
	personal = true
	reserving = false
	type = "transport"

func doable():
	return object.can_interact.has(actor.id)
	
	
