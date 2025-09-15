extends Object
class_name AbilityBase

var rules

var title
var key

var timed = false

var temporary = false

var action = "nothing"



var attacks = {}

#Toggles on if conditions are met, off if not
var toggling = false

var conditions = []


#Passive effects granted by the ability
var effects = {}

func get_modifiers():
	return effects

func _init(gamedata, abilitydata = {}):
	if abilitydata.has("temporary"):
		temporary = abilitydata.temporary
	if abilitydata.has("conditions"):
		toggling = true
		for condata in abilitydata.conditions:
			var condition = gamedata.make_condition(condata)
			conditions.append(condition)
			
func check_toggle(instance):
	if check_conditions(instance.unit):
		instance.unit.toggle_ability(instance, true)
	else:
		instance.unit.toggle_ability(instance, false)
	
			
func check_conditions(target):
	var result = true
	for condition in conditions:
		if !condition.fits(target, null):
			result = false
	return result

func active(unit):
	var result = true
	for condition in conditions:
		if !condition.met(unit):
			result = false
	return result

func make_power(instance):
	var power = AbilityPower.new({
		"name": key,
		"on_cast": action,
		"cast_args": [],
		"category": "unit",
		"ability": instance
	}, rules)
	power.make_tool()
	return power

func fire(instance):
	pass
