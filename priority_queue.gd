extends Object
class_name PriorityQueue

var items = []
var ids = {}

func insert(item, cost):
	var dict = {"item": item, "cost": cost}
	if items.size() > 0:
		for i in items.size():
			var checkdict = items[i]
			if checkdict.cost > dict.cost:
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
	
func extract():
	var result = items.pop_front()
	return result.item
