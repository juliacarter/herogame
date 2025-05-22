extends Object
class_name Buildup

var key = "poison"

#amount of buildup the unit currently has
var current = 0

#amount of buildup needed to trigger effect on unit
var needed = 10

#unit the buildup is associated with
var unit

func _init(newunit):
	unit = newunit
	
func build(val):
	current += val
	if needed <= current:
		current -= needed
		fire()
	
func fire():
	pass
