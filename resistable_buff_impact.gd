extends Impact
class_name ResistableBuffImpact

#MAGNITUDE = resistability of attack

var buff = ""

#stacks to apply on no resist
var count = 10

var chance = 20

#resistance the impact is rolled against
var resistance = "genericresist"

func _init(impactdata, newori = null):
	super(impactdata, newori)
	buff = impactdata.buffname
	if impactdata.has("chance"):
		chance = impactdata.chance
	
func fire(target, crits = 0, flat_bonus = 0, percent_bonus = 0):
	var percent = chance + flat_bonus
	var bonus = (percent_bonus / 100) * chance
	percent += bonus
	for crit in crits:
		percent *= 1.5
	#target.apply_buff_by_name(buff)
	target.resistable_buff(buff, percent, resistance, crits)
