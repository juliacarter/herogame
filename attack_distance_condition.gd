extends Criteria
class_name AttackDistanceCondition

var desired = 128

func fits(trigger_by, trigger_for = null):
	#var needed = desired * desired
	var can = desired > trigger_by.last_shot_range
	return can
