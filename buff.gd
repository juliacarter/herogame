extends Object
class_name Buff

var base
var time

#the object that applied the buff
var parent

#the unit affected by the buff
var unit

var count = 0

func get_tiptitle():
	return base.tipname + " " + String.num(count)

func apply(unit):
	base.apply(unit)

func _init(newbase, newunit):
	unit = newunit
	base = newbase
	time = base.duration

func tick(delta):
	if base.timed:
		time -= delta
	base.tick(delta, unit)
