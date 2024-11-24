extends Object
class_name Ability

var base: AbilityBase
var unit: Unit

var time = 0

var timed = false

var autocast = false

var targeter

var count = -1

var state = false

func object_name(length = "full"):
	return base.key

func fire(target):
	base.fire_at(self, target)

func think(delta):
	if timed:
		time -= delta

func _init(newbase, newunit):
	base = newbase
	timed = newbase.timed
	if timed:
		time = newbase.cooldown
	unit = newunit

func make_tool():
	var power = base.make_power(self)
	power.count = count
	return power
