extends Object
class_name Effect



var base
var unit
var stacks

#The parent that applies the effect
#Use only when the affect is applied by another object
var parent

var trigger_instances = []

func _init(newbase, newunit, newstacks):
	base = newbase
	unit = newunit
	stacks = newstacks

func tick(delta):
	base.tick(delta, unit, stacks)
