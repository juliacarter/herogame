extends Object
class_name Shelf

var whitelist = []
var contents = {}
var requests = {}

#Objects allowed to be stored in this shelf
var wants = [
	
]

var size
var capacity_remaining

var location

var name

func return_stacks():
	var result = []
	for key in contents:
		var item = contents[key]
		result.append(item)
	return result

func add_whitelist(key):
	if whitelist.find(key) == -1:
		whitelist.append(key)
	
func remove_whitelist(key):
	var i = whitelist.find(key)
	if i != -1:
		whitelist.pop_at(i)

func _init(data):
	name = data.name
	if data.has(whitelist):
		whitelist = whitelist
	
func store(stack):
	stack.shelf = self
	if requests.has(stack.base.id):
		requests[stack.base.id] -= stack.count
	if contents.has(stack.base.id):
		contents[stack.base.id].merge(stack)
		return false
	else:
		contents.merge({
			stack.base.id: stack
		})
		return true

func split(base, count):
	var result = null
	if contents.has(base.id):
		result = contents[base.id].split(count)
		result.location = location
		location.map.place_stack(result)
		if contents[base.id].count <= 0:
			if !(location is Unit):
				pass
			if contents[base.id].reserved_count > 0:
				pass
			if name == "storage":
				pass
			#location.map.remove_stack(contents[base.id])
			contents.erase(base.id)
	else:
		pass
	return result
	
func peek(base):
	if contents.has(base.id):
		return contents[base.id].count
	return 0
	
func has(base, count):
	var result = 0
	for key in contents:
		var content = contents[key]
		if content.base == base:
			result = content.count
			if result > count:
				result = count
	return result
	

func remove(base, count):
	if contents.has(base):
		contents[base].count -= count
		if contents[base].count <= 0:
			location.map.remove_stack(contents[base])
			contents.erase(base)
			return false
	return true


func save():
	var stacks = {}
	for key in contents:
		var stack = contents[key]
		var stackdata = stack.save()
		stacks.merge({
			key: stackdata
		})
	var save_dict = {
		"size": size,
		"name": name,
		"location": location.id,
		"contents": stacks,
	}
	return save_dict
