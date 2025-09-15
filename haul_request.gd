extends Object
class_name HaulRequest

var count
var stack
var destination
var shelf

var from_shelf = ""
var to_shelf = ""

var final
var job

func save():
	var save_dict = {
		"count": count,
		"stack": stack.id,
		"destination": destination.id,
		"shelf": shelf.id,
		"final": final,
		"job": job.id
	}

func _init(newstack, newcount, newdes, newfrom, newto, newfinal, newjob):
	stack = newstack
	count = newcount
	destination = newdes
	from_shelf = newfrom
	to_shelf = newto
	final = newfinal
	job = newjob
