extends Condition
class_name RandomChanceCondition

var value = 10

func _init(data):
	super(data)
	if data.has("value"):
		value = data.value

func fits(unit, target = null):
	var roll = randi() % 100
	if roll < value:
		return true
	return false
