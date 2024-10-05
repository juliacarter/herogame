extends Task
class_name PatrolTask

var waypoint
var patrol
var index

func _init(newpoint, newpatrol, newindex):
	waypoint = newpoint
	target = waypoint.position
	patrol = newpatrol
	index = newindex
	reserving = false
	speed = "walk"
	type = "idle"
	
func get_square(origin = null, reserving = false, spotname = "patrol"):
	return waypoint.get_square()
	
func next_patrol():
	var next = index + 1
	if next >= patrol.nodes.size():
		next = 0
	if next != index:
		var nextnode = patrol.nodes[next]
		var result = PatrolTask.new(nextnode, patrol, next)
		return result
	else:
		return null
