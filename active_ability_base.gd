extends AbilityBase
class_name ActiveAbilityBase



var cooldown = 0

var automatic = false

var prime_action = ""
var fire_action = ""
var fire_args = []

var targeted = true



#Must be met for the spell to autocast, but not for the spell to be manually cast. Prevents the ability from being used when its not useful, but lets the player do whatever they want
var auto_conditions = []


var range = 128

func _init(gamedata, abilitydata):
	super(gamedata, abilitydata)
	if abilitydata.has("automatic"):
		automatic = abilitydata.automatic
	if abilitydata.has("fire_action"):
		fire_action = abilitydata.fire_action
	if abilitydata.has("fire_args"):
		fire_args = abilitydata.fire_args.duplicate()
	if abilitydata.has("cooldown"):
		cooldown = abilitydata.cooldown
	#Active abilities usually use cooldown timers
	timed = true
	#Active abilities don't toggle for now, but they probably should eventually. It'd make it easier to "gray out" inactive abilities.
	toggling = false

func make_power(instance):
	var power = AbilityPower.new({
		"name": key,
		"on_prime": prime_action,
		"prime_args": [],
		"on_cast": "order_cast_at_hovered",
		"cast_args": [instance],
		"category": "unit",
		"ability": instance
	})
	power.make_tool()
	return power

func fire(instance, delta = 0.0):
	instance.time = cooldown
	var args = fire_args.duplicate()
	args.push_front(instance)
	#if everyframe:
	#	args.push_front(delta)
	rules.callv(fire_action, args)
	
func fire_at(instance, target, delta = 0.0):
	instance.time = cooldown
	var args = fire_args.duplicate()
	args.push_front(instance)
	args.push_front(target)
	#if everyframe:
	#	args.push_front(delta)
	rules.callv(fire_action, args)
