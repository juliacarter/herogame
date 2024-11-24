extends Object
class_name Buff

var base
var time

#the object that applied the buff
var parent

func _init(newbase):
	base = newbase
	time = base.duration
