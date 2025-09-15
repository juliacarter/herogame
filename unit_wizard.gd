extends Object
#Object used to generate new units
class_name UnitWizard

var data
var rules

var unitscene = load("res://scene/unit/unit.tscn")

#Unit bases should be provided without equipment, otherwise cost will end up somewhat inflated
var base

var starting_price = 10
var max_spend = 20

#Equipment options by slot, with prices
var equipment = {}

#Fail to generate if an option can't be purchased for any of these slots
var needs_fill = {}

#Items that spawn in the inventory
var loot = []

#Upgrades that can be bought for the unit
var upgrades = {}
#The maximum upgrades that can be purchased in each "slot", -1 is unlimited
var upgrade_max = {}


func _init(gamerules, gamedata, dict):
	rules = gamerules
	data = gamedata
	if dict.has("base"):
		base = dict.base
	if dict.has("equipment"):
		equipment = dict.equipment.duplicate(true)
	if dict.has("upgrades"):
		upgrades = dict.upgrades.duplicate(true)
	if dict.has("upgrade_max"):
		upgrade_max = dict.upgrade_max.duplicate(true)

#Value is the total amount of resources that can be spent on the unit. If value = -1, there is no limit
func generate_unit(value = -1, wants_equipment = true, wants_upgrades = true):
	if value > max_spend || value == -1:
		value = max_spend
	if value < starting_price && value != -1:
		return null
	var total = starting_price
	var unit = unitscene.instantiate()
	unit.load_data(rules, data, base, "default", false)
	unit.generate_name()
	if wants_equipment:
		for slot in equipment:
			var sloptions = equipment[slot]
			var possible = []
			for requis in sloptions:
				if total + requis.cost <= value || value == -1:
					possible.append(requis)
			if possible != []:
				var rand = randi() % possible.size()
				var option = possible[rand]
				unit.equip_base(option.obj, slot)
				total += option.cost
	var done = false
	var used = []
	var slot_count = {}
	while !done:
		var possible = {}
		for key in upgrades:
			var options = upgrades[key]
			if !slot_count.has(key) || slot_count[key] < upgrade_max[key]:
				for req in options:
					if (total + req.cost <= value || value == -1) && used.find(req) == -1:
						possible.merge({
							key: []
						})
						possible[key].append(req)
		if possible != {}:
			var keypos = randi() % possible.size()
			var key = possible.keys()[keypos]
			var sloptions = possible[key]
			if sloptions != []:
				var rand = randi() % sloptions.size()
				var option = sloptions[rand]
				used.append(option)
				unit.learn_base(option.obj)
				total += option.cost
				slot_count.merge({
					key: 0
				})
				slot_count[key] += 1
			else:
				done = true
		else:
			done = true
	if total > value && value != -1:
		return null
	unit.id = rules.assign_id(unit)
	return {
		"unit": unit,
		"cost": total
	}
