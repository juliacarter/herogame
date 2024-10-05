extends Object
class_name TaskQueue

var head
var tail

var tag

func get_items():
	if(head != null):
		return head.get_queue(tag)
	else:
		return "Head is nil for " + tag

func _init(new_tag):
	tag = new_tag

func get_head():
	return head
	
func get_tail():
	return tail

func enqueue(task):
	if(head == null):
		print("New head set for " + tag)
		head = task
	elif(tail == null):
		print("Back Set for Head at " + tag)
		head.set_back(tag, task)
		tail = task
	else:
		print("Back Set for Tail at" + tag)
		tail.set_back(tag, task)
		tail = task
	
func is_empty():
	if(head == null):
		return true
	else:
		return false
	
func pop():
	print("Popping: " + tag)
	var result = null
	if(head != null):
		var nexthead = head.get_previous(tag)
		result = head.pop()
		print(result.text)
		head = nexthead
	return result
