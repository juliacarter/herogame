extends Object
class_name Faction

signal faction_wealth_increased(faction, amount)
signal faction_boldness_increased(faction, amount)
signal faction_research_increased(faction, amount)

signal faction_threat_created(faction, threat)

signal faction_buildup(faction, amount)
signal faction_buildup_full(faction)

var key = ""

var id

var rules

var base
var color

var heat = 0.0
var interest = 0

#grants a bonus to points used for unit generation
var research = 0
var boldness = 5
var wealth = 0

var buildup = 0
#the amount of Buildup needed for the next Doom Threat
var buildup_to_doom = 10

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


var operation = {}

#units not currently assigned to an Operation
var inactive_units = {}
#Units currently existing in the game world that belong to this faction
var units = {}

#units organized by role
var units_by_role = {}

#The unit lists currently in use by the faction. These can be modified
var unitlists = {
	
}

#new unitlist logic. sort this dictionary by role
var lists = {
	
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

#resources available to the faction
var resources = {}

func gain_heat(amount):
	heat += amount

func apply_buildup():
	pass
	
func start_threat(type = "doom"):
	pass

func object_name(l=""):
	return alignment

func gain_research(amount):
	research += amount

func get_threat():
	var potential = []
	var result
	for key in threats:
		var threat = threats[key]
		potential.append(threat)
	if potential != []:
		var i = randi() % potential.size()
		result = potential[i]
	return result

func _init(newbase, newrules):
	rules = newrules
	id = rules.assign_id(self)
	var data = rules.data
	alignment = newbase.alignment
	for key in newbase.threats:
		if data.missions_to_load.has(key):
			var threat = Threat.new(data, data.missions_to_load[key])
			threat.faction = self
			threats.merge({
				key: threat
			})
	for role in newbase.lists:
		var options = newbase.lists[role]
		for listname in options:
			var weight = options[listname]
			if data.lists.unit.has(listname):
				var list = data.lists.unit[listname]
				lists.merge({
					role: []
				})
				lists[role].append(list)
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
	if faction.key != key:
		return "enemy"
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
		
func add_unit(unit):
	units.merge({
		unit.id: unit
	})
	inactive_units.merge({
		unit.id: unit
	})
	for role in unit.meta_roles:
		add_unit_by_role(unit, role)
	
func add_unit_by_role(unit, role):
	units_by_role.merge({
		role: {}
	})
	units_by_role[role].merge({
		unit.id: unit
	})
	
func initialize():
	var newunits = []
	if key != "player":
		for i in 5:
			var unit = generate_units("basic", 1, 100)
			newunits.append(unit.values()[0])
	
#desired = {meta_role1: points1, meta_role2: points2, ...}
#attach a randomly selected group of units to a given encounter
#randomly select inactive units that match meta_roles in desired until all points are spent
func send_units_to_encounter(encounter, desired, role):
	var result = {}
	for meta_role in desired:
		result.merge({
			meta_role: []
		})
		
		var points = desired[meta_role]
		var done = false
		while !done:
			var options = []
			for key in inactive_units:
				var unit = inactive_units[key]
				if unit.meta_roles.find(meta_role) != -1:
					if unit.point_value <= points:
						options.append(unit)
			if options != []:
				var rand = randi() % options.size()
				var unit = options[rand]
				points -= unit.point_value
				send_out(unit)
				result[meta_role].append(unit)
				options.pop_at(rand)
			else:
				done = true
	
func pick_units_for_metarole(metarole, points):
	var done = false
	var result = []
	while !done:
		var options = []
		for key in inactive_units:
			var unit = inactive_units[key]
			if unit.meta_roles.find(metarole) != -1:
				if unit.point_value <= points:
					options.append(unit)
		if options != []:
			var rand = randi() % options.size()
			var unit = options[rand]
			points -= unit.point_value
			send_out(unit)
			result.append(unit)
			options.pop_at(rand)
		else:
			done = true
	return result
	
#remove these units from Inactive Units
func send_on_operation(newunits, operation):
	make_active(newunits)
	operation.assign_units(newunits)
		
func make_active(newunits):
	for unit in newunits:
		send_out(unit)
		
func send_out(unit):
	inactive_units.erase(unit.id)
	
#add these units back to Inactive Units
func return_from_operation(newunits):
	for unit in newunits:
		inactive_units.merge({
			unit.id: unit
		})
	
#return the unit to the inactive unit queue
func return_home(unit):
	inactive_units.merge({
		unit.id: unit
	})
	
func remove_unit(unit):
	units.erase(unit.id)
	for role in unit.meta_roles:
		remove_unit_by_role(unit, role)
	
func remove_unit_by_role(unit, role):
	if units_by_role.has(role):
		units_by_role[role].erase(unit.id)
		
func generate_units(type, max, starting_points, research_scale = 1.0, use_research = true):
	var points = starting_points
	var research_bonus = (rules.chaos * research_scale)
	points += research_bonus
	var options = lists[type]
	var i = randi() % options.size()
	var selected = options[i]
	var newunits = selected.generate_units(points, max)
	for unit in newunits:
		add_unit(unit)
	return units
	
func generate_one_unit(type = "basic", starting_points = 100):
	var newunits = generate_units(type, 1, starting_points)
	pass
		
#select a number of random units of the given type
func select_units(role, count):
	var selected = []
	if units_by_role.has(role):
		var options = units_by_role[role]
		for i in count:
			var j = randi() % options.size()
			var unit = options.values()[j]
			selected.append(unit)
	return selected
		
func get_units(count):
	var list = base.unitlists.values()[randi() % base.unitlists.size()]
	return list.generate_amount(count)
	
