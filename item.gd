extends Object
class_name Stack

signal stack_empty(stack)
signal item_grabbed(stack, count)

var rules

var id
var base
var count

var map

var location

var reserved
var reserved_count = 0

var shelf

var needs_haul

var job = null

var storing = false

var equipped = false

var haul_tasks = []

func add_haul_task(task):
	haul_tasks.append(task)
	
	
func remove_haul_task(task):
	var i = haul_tasks.find(task)
	if i != -1:
		haul_tasks.pop_at(i)
		reserved_count -= task.count

#Check to see if this stack is stored in an appropriate location
#Appropriate = stack is whitelisted in countainer, stack is not held by unit (without being reserved)
#Stack also needs to be inside a shelf not marked "Output"
#Also check to see if there is not a higher-priority container for the item. If so, container is non-suitable. !!!AFTER PRIORITY IS IMPLEMENTED!!!
func storage_suitability():
	#Only check non-reserved items in the stack
	var storable = count - reserved_count
	if storable > 0:
		if shelf.name == "output" || location is FloorItem:
			#if !storing:
				#storing = true
			await order_storage(storable)
		else:
			if shelf.whitelist != [] && shelf.whitelist.find(base.key) == -1:
				#if !storing:
					#storing = true
				await order_storage(storable)
	elif storable < 0:
		pass
		
#Send a specific amount of this stack to the taskmaster for hauling
func order_storage(stored):
	if stored > 0:
		map.taskmaster.store_task(self, stored)

func _init(gamerules, newbase, newcount, grid):
	rules = gamerules
	base = newbase
	count = newcount
	map = grid
	
func store(newcontainer):
	location = newcontainer
	
func merge(stack):
	count += stack.count
	reserved_count += stack.reserved_count
	stack.stack_empty.emit(stack)
	#await map.remove_stack(stack)
	pass
	
func split(splitcount):
	if splitcount == 0:
		pass
	#if reserved:
		#reserved_count -= splitcount
	count -= splitcount
	var newstack = Stack.new(rules, base, splitcount, map)
	newstack.rules = rules
	newstack.id = rules.assign_id(self)
	newstack.location = location
	if reserved:
		newstack.reserved = true
		newstack.reserved_count = splitcount
		
		if reserved_count <= 0:
			reserved = false
			reserved_count = 0
	if count <= 0:
		stack_empty.emit(self)
	return newstack

func save():
	var save_dict = {
		"id": id,
		"count": count,
		"reserved": reserved,
		"needs_haul": needs_haul,
		"location": location.id,
		"base": base.key,
		"map": map.id
	}
	if job != null:
		save_dict.merge({
			"job": job.id
		})
	return save_dict
