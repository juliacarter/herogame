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

var gainrate = 0.0

#the amount that gets converted into Damage after this stat is spent
var spend_ratio = 0.0

var soft_cap = true

#lasting damage that limits Fuel max
#Wounds and Fatigue
var damage = 0

var flat_regenmods = []
#percent modifier applied to regen after flat mods applied
var percent_regenmods = []
#flat modifiers applied after % bonuses
var bonus_regenmods = []

func regenerate(delta):
	var amount = total_gain() * delta
	var val = modify(amount)
	return val

func visual_gain():
	var base = total_gain()
	if title == "energy":
		for spell in unit.toggled_spells:
			base += spell.energy_cost*-1
	var cap = current_max()
	if value > cap:
		base /= 2
	#base = get_softcapped_amount(base)
	return base

func total_gain():
	var rate = gainrate
	if unit != null:
		for modname in flat_regenmods:
			var mod = unit.mods.ret(modname)
			rate += mod
		var total_percent = 0
		for modname in percent_regenmods:
			var mod = unit.mods.ret(modname)
			total_percent += mod
		if total_percent != 0:
			var modifier = total_percent / 100
			var bonus = modifier * rate
			rate += bonus
		for modname in bonus_regenmods:
			var mod = unit.mods.ret(modname)
			rate += mod
	return rate

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

func spend(num):
	modify(num)
	var dam_amount = num * spend_ratio
	if dam_amount < 0:
		add_damage(dam_amount * -1)

func get_final(num):
	pass

func get_softcapped_amount(gained):
	if gained < 0:
		return gained
	var cap = current_max()
	var new = value + gained
	if new < cap:
		return gained
	var old = value
	var base = old - cap
	if base > 0:
		base = 0
	var overflow = gained + base
	overflow /= 2.0
	var result = overflow + base*-1
	return result
	

func modify(num):
	var cap = current_max()
	var old = value
	var new = old + num
	var gained = num
	if num > 0.0:
		if new > cap:
			if soft_cap:
				gained = get_softcapped_amount(gained)
				new = old + gained
			else:
				gained = cap - old
				new = cap
	if(new >= max):
		gained = max - old
		value = max
	elif new < 0.0:
		value = 0.0
	else:
		value = new
	for abdata in abilities:
		if ability_valid(abdata):
			if abdata.bracket != 0.0:
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
	return gained
	
func current_max():
	return max - damage
	
func add_damage(amount):
	damage += amount
	var cap = current_max()
	if !soft_cap:
		if value > cap:
			value = cap
	
func heal(amount):
	heal_damage(amount)
	modify(amount)
	
func heal_damage(amount):
	damage -= amount
	if damage < 0:
		damage = 0
	
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
	if data.has("flat_regenmods"):
		flat_regenmods = data.flat_regenmods.duplicate()
	if data.has("percent_regenmods"):
		percent_regenmods = data.percent_regenmods.duplicate()
	if data.has("bonus_regenmods"):
		bonus_regenmods = data.bonus_regenmods.duplicate()
	if data.has("defaultgain"):
		gainrate = data.defaultgain
	if data.has("spend_ratio"):
		spend_ratio = data.spend_ratio
	if data.has("soft_cap"):
		soft_cap = data.soft_cap
	value = float(data.num)
	category = data.category
