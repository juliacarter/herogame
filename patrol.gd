extends Object
class_name Patrol

var nodes = []

var id

var priority = 1

var desired = 5

var has = 0

var map

#IDs for classes which are allowed to be assigned to this patrol
var classes = []


func change_priority(new):
	map.remove_patrol_priority(self)
	priority = new
	map.add_patrol_priority(self)

func do_indexes():
	for i in nodes.size():
		var node = nodes[i]
		node.index = i

func remove_node(node):
	var i = nodes.find(node)
	if i != -1:
		node.pop_at(i)
	
func add_node(node):
	node.index = nodes.size()
	node.patrol = self
	nodes.append(node)
