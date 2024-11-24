extends Condition
class_name AttackDistanceCondition

var desired = 128

var greater = true

func _init(data):
	super(data)
	if data.has("greater"):
		greater = data.greater

func fits(trigger_by, trigger_for = null):
	#var needed = desired * desired
	var can = false
	if !greater:
		can = desired > trigger_by.last_shot_range
	else:
		can = desired < trigger_by.last_shot_range
	return can
