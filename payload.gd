extends Object
#applies a one-shot effect to an object
class_name Payload

var data
var rules

#Payload delivers these buffs
var buffs = []

#Payload delivers each of these attacks one time each
var attacks = []

#
var parent

func _init(gamerules, gamedata, payloaddata, caster = null):
	rules = gamerules
	data = gamedata
	parent = caster
	if payloaddata.has("attacks"):
		for attackname in payloaddata.attacks:
			if data.weapons.has(attackname):
				var attdata = data.weapons[attackname]
				var attack = Attack.new(rules, attdata, parent)
				attack.unit = parent
				attacks.append(attack)

func fire_at(target, pos = null):
	for attack in attacks:
		attack.fire_weapon(target, pos)
