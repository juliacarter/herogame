extends Stack
class_name PoolStack

var player

func _init(newbase, grid):
	base = newbase
	map = grid

func split(splitcount):
	#count -= splitcount
	var newstack = Stack.new(rules, base, splitcount, map)
	map.place_stack(newstack)
	return newstack
