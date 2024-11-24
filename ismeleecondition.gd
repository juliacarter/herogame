extends Condition
class_name MeleeAttackCondition

func fits(unit, target = null):
	return unit.melee
