extends Object
class_name Multiqueue

var queues = {}

func multi_enqueue(task):
	for tag in task.tags:
		print(tag)
		if(!queues.has(tag)):
			queues[tag] = TaskQueue.new(tag)
		queues[tag].enqueue(task)
		
func add_queue(tag):
	if(!queues.has(tag)):
		queues[tag] = TaskQueue.new(tag)
		
func tag_pop(tag):
	print("Multiqueue Popping: " + tag)
	var result = queues[tag].pop()
	print(result)
	return result

func get_queue(tag):
	if(queues.has(tag)):
		return queues[tag].get_items()
	else:
		return "Invalid queue."
