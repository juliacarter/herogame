extends Object
class_name UnitShelf

var object

var active = false

var units = {}
var capacity = 10000

func _init(newobject):
	object = newobject

func store_unit(unit):
	unit.stored_in = object
	unit.stored = true
	if units.size() < capacity:
		units.merge({
			unit.id: unit
		})
		return true
	else:
		return false
