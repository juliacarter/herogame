extends Impact
class_name BuildupImpact

#the effect this Impact builds up to
var effect = ""

#the "damage type" this Impact builds up to, for determining resistances
var damage_type = ""

func fire(target, crits = 0, flat_bonus = 0, percent_bonus = 0):
	target.apply_buildup("poison", magnitude)
