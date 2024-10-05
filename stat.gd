extends Object
class_name Stat

var title

var category
var type = ""

#Abilities applied by the stat
#Format
#{
#effect: Effect -- the Effect applied
#threshold: int -- the value which this effect is applied, if doesnt exist threshold = 0
#threshold_above: bool -- whether the effect is applied above the threshold, or below if false, if doesn't exist set = true
#stacks: int -- the amount applied for each bracket, if doesn't exist stacks = 1
#bracket -- the amount of each variable needed to increase the value, if doesn't exist set = 0 (meaning unit get 1 stack as long as the threshold is met, and none otherwise)
#}

var abilities = [
	
]

#Extra abilities that have been added by the unit
var added_abilities = []

#Check this when the value changes, if any non-valid abilities are here then remove them
var applied_abilities = {}

var unit

var value
var max

#the real limit for the stat, different from the max
var limit


func ability_valid(abdata):
	var has = false
	if abdata.threshold_above:
		if value >= abdata.threshold:
			has = true
	else:
		if value <= abdata.threshold:
			has = true
	return has
	
func set_value(num):
	value = num
	initial_calc()
	
		
func modify(num):
	var old = value
	var new = old + num
	if(new >= max):
		value = max
	elif new < 0:
		value = 0
	else:
		value = new
	for abdata in abilities:
		if ability_valid(abdata):
			if abdata.bracket != 0:
				var newbracket = int(new / abdata.bracket)
				var oldbracket = int(old / abdata.bracket)
				var bracket = newbracket - oldbracket
				var mod = abdata.stacks * bracket
				unit.add_ability(abdata.ability, mod)
				if !applied_abilities.has(abdata):
					applied_abilities.merge({
						abdata: mod
					})
				else:
					applied_abilities[abdata] += mod
			else:
				if !applied_abilities.has(abdata):
					applied_abilities.merge({
						abdata: 1
					})
					unit.add_ability(abdata.ability, 1)
		else:
			if applied_abilities.has(abdata):
				unit.remove_ability(abdata.ability, 1)
	
func initial_calc():
	for abdata in abilities:
		if ability_valid(abdata):
			if abdata.bracket != 0:
				var bracket = int(value / abdata.bracket)
				var mod = abdata.stacks * bracket
				applied_abilities.merge({
					abdata: mod
				}, true)
				unit.add_ability(abdata.ability, mod, true)
			else:
				applied_abilities.merge({
					abdata: 1
				}, true)
				unit.add_ability(abdata.ability, 1, true)

func _init(data):
	title = data.name
	if data.has("abilities"):
		abilities = data.abilities.duplicate()
	value = float(data.num)
	category = data.category
