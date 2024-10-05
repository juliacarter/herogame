extends Object
class_name Navpath

var index = 0
var path = []

var final: Vector2

var destination

func _init(newpath, newfinal):
	final = newfinal
	for node in newpath:
		path.append(node)
	if newpath.size() != 0:
		destination = newpath[newpath.size()-1]
