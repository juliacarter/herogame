extends Task
class_name EscortTask

var client

func _init(newjob, unit, target, original = true):
	job = newjob
	client = unit
	object = target
	type = "startescort"
	desired_role = "worker"
	if original:
		next_action = EscortTask.new(job, client, object, false)
		next_action.type = "escort"

func get_square(origin = null, reserving = true, spotname = "interact"):
	if type == "startescort":
		return client.get_square()
	elif type == "escort":
		return object.get_square(actor, false)
		
func doable():
	if type == "startescort":
		return client.can_interact.has(actor.id)
	elif type == "escort":
		return object.can_interact.has(actor.id)
