extends Outcome
class_name ApplyBuffOutcome

#if false, buff the unit that carries the trigger, otherwise buff the unit that triggered it
var buff_target = false

var buff = "poison"

func fire(target):
	if rules.data.buffs.has(buff):
		buff = rules.data.buffs[buff]
		target.apply_buff(buff)
