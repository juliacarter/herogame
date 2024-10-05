extends Object
class_name HaulRequest

var count
var stack
var destination
var shelf
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

func _init(newstack, newcount, newdes, newshelf, newfinal, newjob):
	stack = newstack
	count = newcount
	destination = newdes
	shelf = newshelf
	final = newfinal
	job = newjob
