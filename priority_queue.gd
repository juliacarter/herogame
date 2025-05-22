extends Object
class_name PriorityQueue

var items = []
var ids = {}

#find the fist item matching signature, remove it, return its cost
func take(item):
	var found = -1
	for i in items.size():
		var checkdict = items[i]
		if checkdict.item == item:
			found = i
			break
	if found != -1:
		var checkdict = items[found]
		items.pop_at(found)
		ids.erase(item.id)
		return checkdict.cost
	return null

#find the first item matching signature, Dont Remove, check cost
func check(item):
	var found = -1
	for i in items.size():
		var checkdict = items[i]
		if checkdict.item == item:
			found = i
			break
	if found != -1:
		var checkdict = items[found]
		return checkdict.cost
	return null

func insert(item, cost):
	var dict = {"item": item, "cost": cost}
	if items.size() > 0:
		for i in items.size():
			var checkdict = items[i]
			if checkdict.cost < dict.cost:
				items.insert(i, dict)
				ids.merge({
					item.id: dict
				})
				return
	items.push_back(dict)
	
func empty():
	return items.is_empty()
	

	
func priority_override_check(item, cost):
	var found = false
	if ids.has(item.id):
		var dict = ids[item.id]
		found = true
		if dict.cost > cost:
			items.pop_at(items.find(dict))
			ids.erase(dict.item.id)
			return false
	return found
	
func peek():
	if items != []:
		var result = items[0]
		return result.item
	else:
		return null
	
func extract():
	var result = items.pop_front()
	return result.item
