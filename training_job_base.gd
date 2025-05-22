extends JobBase
class_name TrainingJobBase

func can_perform(unit, slot = "interact"):
	var old = super(unit, slot)
	var new = unit.level < jobdata.max_level
	return old && new
