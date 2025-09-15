extends Spell
#an AoE spell that can be placed anywhere
#with a visual indicator
class_name PlacedAreaSpell

var aoedata

var radius = 64
var max_distance = 64

var shape = ""

var payloads = []

func _init(gamedata, spelldata, parent = null):
	super(gamedata, spelldata, parent)
	range = 128
	if spelldata.has("max_distance"):
		max_distance = spelldata.max_distance
	if spelldata.has("radius"):
		radius = spelldata.radius
	if spelldata.has("shape"):
		shape = spelldata.shape
	elif shape == "":
		shape = "AreaEffectCircle"
	if spelldata.has("payloads"):
		payloads = spelldata.payloads.duplicate(true)
	if spelldata.has("aoedata"):
		aoedata = spelldata.aoedata
	else:
		aoedata = {
			"shape": shape,
			"max_distance": max_distance,
			"payloads": payloads,
			"radius": radius,
		}
	fire_action = "aoe_at_position"
	include_caster = true
	targeted = true
	fire_args = [aoedata]
	prime_action = "make_ghost"
	prime_args = [aoedata]

#fire at targeted square
func fire_at(target, delta = 0.0):
	rules.aoe_at_position(unit, target, aoedata)

func can_fire(target):
	var energy = has_energy()
	var ammo_valid = has_ammo()
	#var range = in_range(target)
	return energy && ammo_valid

func make_plan():
	var power = AreaPlanPower.new({
		"name": key,
		"on_cast": "fire_attack_at_target",
		"cast_args": [],
		"category": "unit",
		"action": self
	}, rules)
	power.make_tool()
	return power

func make_power():
	var power = ActionPower.new({
		"name": key,
		"on_cast": "order_spellcast_at_mousepos",
		"cast_args": [self, unit],
		"on_prime": prime_action,
		"prime_args": prime_args,
		"caster": unit,
		"category": "unit",
		"action": self
	}, rules)
	power.make_tool()
	return power
