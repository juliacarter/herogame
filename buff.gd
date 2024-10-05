extends Object
class_name Buff

var base
var time

func _init(newbase):
	base = newbase
	time = base.duration
