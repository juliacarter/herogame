extends Object
class_name QueueTag

var name
var queue: TaskQueue

func _init(new_name):
	name = new_name

func assign_queue(new_queue):
	queue = new_queue
