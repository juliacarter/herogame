extends Action
class_name Spell

var data
var rules

var time_needed = 0
var time = 0

var automatic = false

var prime_action = ""
var fire_action = ""
var fire_args = []

var target_function = ""
var target_args = []

var targeted = true

var conditions = []

#Must be met for the spell to autocast, but not for the spell to be manually cast. Prevents the ability from being used when its not useful, but lets the player do whatever they want
var auto_conditions = []

var key = ""
var parent

var range = 128

var attention_cost = 0

var everyframe = false

func find_target(targeter):
	var args = target_args.duplicate()
	args.push_front(targeter)
	var result = callv(target_function, args)
	return result
	
func fire_at(target, delta = 0.0):
	time = time_needed
	var args = fire_args.duplicate()
	args.push_front(target)
	if everyframe:
		args.push_front(delta)
	rules.callv(fire_action, args)
	
func get_targeter(targeter):
	return targeter
	
func get_random_ally(targeter, radius):
	pass

func check_conditions(target):
	var result = true
	for condition in conditions:
		if !condition.fits(target, null):
			result = false
	return result

func _init(gamedata, spelldata):
	data = gamedata
	if spelldata.has("cooldown"):
		time_needed = spelldata.cooldown
		time = time_needed
	if spelldata.has("attention_cost"):
		attention_cost = spelldata.attention_cost
	if spelldata.has("prime_action"):
		prime_action = spelldata.prime_action
	if spelldata.has("fire_action"):
		fire_action = spelldata.fire_action
	if spelldata.has("fire_args"):
		fire_args = spelldata.fire_args.duplicate()
	if spelldata.has("automatic"):
		automatic = spelldata.automatic
	if spelldata.has("range"):
		range = spelldata.range
	if spelldata.has("everyframe"):
		everyframe = spelldata.everyframe
	if spelldata.has("conditions"):
		var newcon = spelldata.conditions
		for condata in newcon:
			var condition = data.make_condition(condata)
			conditions.append(condition)
	if spelldata.has("target_function"):
		target_function = spelldata.target_function
	if spelldata.has("target_args"):
		target_args = spelldata.target_args
	pass
	
func cooldown(delta):
	time -= delta
	if time < 0:
		time = 0
	
