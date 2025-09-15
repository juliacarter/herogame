extends Action
class_name Spell


var automatic = false

var prime_action = ""
var prime_args = []
var fire_action = ""
var fire_args = []

var target_function = ""
var target_args = []

var targeted = true

var conditions = []

#Must be met for the spell to autocast, but not for the spell to be manually cast. Prevents the ability from being used when its not useful, but lets the player do whatever they want
var auto_conditions = []

var parent

var everyframe = false

var include_caster = false
var prime_include_caster = true

#targeter used by the spell
var targeter

#whether this spell can target the ground
#ground targeting spells can be targeted to a specific unit, which will place the AoE on top of them wherever they move
var ground_targeted = false

func make_power():
	var power = ActionPower.new({
		"name": key,
		"on_cast": "order_spellcast_at_target",
		"cast_args": [self, unit],
		"on_prime": prime_action,
		"prime_args": prime_args,
		"category": "unit",
		"action": self
	}, rules)
	power.make_tool()
	return power

func find_target(targeter):
	var args = target_args.duplicate()
	args.push_front(targeter)
	var result = callv(target_function, args)
	return result
	
func fire_at(target, delta = 0.0):
	super(target, delta)
	#time = cooldown
	for impact in impacts:
		impact.fire(target, 0)
	var args = fire_args.duplicate()
	
	if targeted:
		args.push_front(target)
	if include_caster:
		args.push_front(unit)
	if everyframe:
		args.push_front(delta)
	rules.callv(fire_action, args)
	
func fire_at_ground(target, delta = 0.0):
	time = cooldown
	var args = fire_args.duplicate()
	if targeted:
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

func _init(gamedata, spelldata, parent = null):
	super(gamedata, spelldata, parent)
	data = gamedata
	rules = data.rules
	if spelldata.has("targeter"):
		var targetdata = spelldata.targeter
		targeter = Targeter.new(rules, targetdata, parent)
	else:
		targeter = Targeter.new(rules, {}, parent)
	if spelldata.has("prime_action"):
		prime_action = spelldata.prime_action
	if spelldata.has("fire_action"):
		fire_action = spelldata.fire_action
	if spelldata.has("fire_args"):
		fire_args = spelldata.fire_args.duplicate()
	if spelldata.has("automatic"):
		automatic = spelldata.automatic
		autocast = automatic
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
	
	
