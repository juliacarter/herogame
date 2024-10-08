extends Object
class_name Faction

var id

var rules

var base
var color

var heat = 0
var interest = 0

#Do in roughly this order
#Player & Agency Faction
#Modules
#Civilian Faction
#Superteam
#Faction Relationships
#Rivals
#Nemeses

#Each Module applies various Bonuses to the faction, similar to Abilities and Effects with units
var modules = {}

#If a module has the temporary value, put it here
#Modules in here will eventually expire
var timed_modules = {}

#Stores information about each unit class relevant to the faction
#If a controller ever has count == 00 && desired == 0, remove it
var class_controllers = {}

#Each Bonus applies something to the entire faction based on count
#Unique apply_bonus func for each type of bonus
var bonuses = {}

#These Traits are applied to all members of the faction
var traits = {}

#Units currently existing in the game world that belong to this faction
var units = {}

#The unit lists currently in use by the faction. These can be modified
var unitlists = {
	
}

#Threats the faction has available to it when drawing one
var threats = {}

#Crisis the faction becomes
var crisis

var alignment = "hero"

var type = "agency"

var allegiances = {}

#The faction's relationship to other factions
#Used to determine allegiances
var relations = {}

#Used to store "special" units such as Rogues
var members = {}

func _init(newbase, newrules):
	rules = newrules
	id = rules.assign_id(self)
	alignment = newbase.alignment
	type = newbase.type
	base = newbase
	color = base.color
	
#BAD VERSION
#Assign the unit to the correct class controller
func apply_class(unit):
	pass
	
#Remove this unit as part of its current class controller, if any
func remove_class(unit):
	pass
	
#Make a controller for the given Class
func make_controller(newclass):
	pass
	
#Remove the controller for this Class
func remove_controller(newclass):
	pass

#Check each ClassController, removing it if empty and ordering new units if needed
func check_controllers():
	pass
#BAD VERSION ENDS
func generate_wave(name, count):
	if base.waves.has(name):
		var wave = base.waves[name]
		return wave
		
func set_allegiances():
	allegiances = {}
	for key in rules.factions:
		var faction = rules.factions[key]
		var relation = "neutral"
		if faction.alignment == alignment:
			relation = "friend"
		else:
			relation = "enemy"
		relations.merge({
			faction.id: relation
		})
		
func get_relation(faction):
	if faction == null:
		return "neutral"
	if faction.id == id:
		return "friend"
	if relations.has(faction.id):
		var relation = relations[faction.id]
		return relation
	else:
		return "neutral"
		
func select_wave():
	var possible = []
	for key in base.waves.basic:
		var wave = base.waves.basic[key]
		if heat >= wave.heatcost:
			for i in wave.weight:
				possible.append(key)
	if possible != []:
		var i = randi() % possible.size()
		var resultkey = possible[i]
		var result = base.waves.basic[resultkey]
		return result
	else:
		return null
		
func get_units(count):
	var list = base.unitlists.values()[randi() % base.unitlists.size()]
	return list.generate_amount(count)
	
