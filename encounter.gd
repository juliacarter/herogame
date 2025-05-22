extends Object
class_name Encounter

var started = false

var rules
var data

var id

var key = ""

var mapname = "oneobjective"

var quest

var transport
var squads = []
var map

#send player units here when encounter is complete
var return_map

var rewards = []

#var goal = "spy"

var bravery = 100000

var objectivetype = ""
var objective

var units_to_send = []

var units = {}

#units from outside the encounter that have been sent to it
var assigned_units = []

var chaos_per_undefeated = 1

var faction

var units_by_team = {}

#units assigned to each Role within the encounter
var units_by_role = {}

var team_goals = {}

var enemy_bases = []

#The names of each list used as a base by this encounter
var list_data = {}

#Unit lists keyed by role
var unit_lists = {}

var lists = {}

#The total Point Value when genning units for each role
#This can be made more complex later if desired
#add the faction's Research
var roles = {
	"baddies": 50
}

#Roles filled by each faction
var role_factions = {
	"player": null,
	"baddies": null,
}
#points worth of Units to grab from the Faction's persistent units
var desired_unit_types = {
	
}

var desired_placement = {
	"player": "deployment",
	"baddies": "zonespawn"
}

#points worth of "phantom" units to be generated anew for the encounter, by type
#phantom units aren't drawn from the persistent unit pool, and disappear when the encounter ends
#they still come from a faction's Unit List
var desired_unit_generation = {
	"baddies": {"soldier": 200}
}

var orders = []

var zones = {
		#"enemydeployment": [[1,1],[5,5]],
		#"deployment": [[1,6],[7,10]]
	}
	
var type = "mission"

var pindata
var pin

#how many units can be brought into this encounter
var encounter_space = 5

signal encounter_complete(encounter, player_success)

signal encounter_begin

signal location_removed(location)



func get_description():
	return "Lorem ipsum odor amet, consectetuer adipiscing elit. Sem consectetur posuere semper etiam nisi conubia ac iaculis? Orci mus ipsum suspendisse pulvinar potenti lectus. Lacus ut faucibus a ornare vehicula quam metus sed magna. Viverra hac orci in nam vestibulum. Ullamcorper in vestibulum ornare ultrices platea. Augue purus dignissim sem, vestibulum purus aliquam. Adipiscing ipsum odio nisl sapien molestie. Magnis aenean auctor ullamcorper gravida interdum. Porta sodales sagittis enim, lobortis habitasse justo semper."

func object_name(s=""):
	return key

#pick units from this encounter's assigned factions
func pick_units():
	var result = {}
	for role in desired_unit_types:
		var types = desired_unit_types[role]
		var faction = role_factions[role]
		for type in types:
			var points = types[type]
			if faction != null:
				var newunits = faction.pick_units_for_metarole(type, points)
				assign_units_to_role(newunits, role)

#assign a set of units to a specific role within the encounter
func assign_units_to_role(newunits, role = ""):
	for unit in newunits:
		#var unit = newunits[key]
		add_unit(unit, role)

func _init(gamerules, encounterdata):
	pindata = EncounterPinData.new(self)
	var gamedata = gamerules.data
	if encounterdata.has("desired_units"):
		desired_unit_types = encounterdata.desired_units.duplicate()
	for reward in rewards:
		reward.parent = self
	team_goals = encounterdata.team_goals.duplicate()
	for key in encounterdata.lists:
		var list_list = encounterdata.lists[key]
		unit_lists.merge({
			key: []
		})
		for listkey in list_list:
			var list = gamedata.lists.unit[listkey]
			unit_lists[key].append(list)
	for key in encounterdata.roles:
		var role = encounterdata.roles[key]
		var options = role.lists
		lists.merge({
			key: options.duplicate()
		})
	for key in encounterdata.zones:
		var zonedata = encounterdata.zones[key].duplicate()
		zones.merge({
			key: zonedata
		})

func get_objective(team = "player"):
	var goal = team_goals[team]
	if goal == "killall":
		return null
	elif goal == "destroy":
		if map.objectives.has(objectivetype):
			return map.find_objective_tag(objectivetype)
	elif goal == "steal":
		#Find a stealable stack
		pass
	else:
		return null
	
func make_zones():
	for key in zones:
		var corners = zones[key]
		var topleft = corners[0]
		var botright = corners[1]
		var squares = map.get_squares(topleft, botright)
		map.make_zone_from_squares(key, squares)

func save():
	var save_dict = {
		"id": id,
		"transport": transport.id,
		"map": map.id,
		#"goal": goal,
	}

func load_save(savedata):
	id = savedata.id
	#goal = savedata.goal

#create/pick units for this encounter
func generate_encounter():
	var newunits = get_units("baddies")
	var pickedunits = pick_units()
	place_units()
	pass

func start_encounter():
	encounter_begin.emit()

func quest_complete(newquest, success):
	if newquest == quest:
		complete_encounter(success)

func complete_encounter(success):
	squads = []
	encounter_complete.emit(self, success)
	location_removed.emit(self)
	if success:
		fire_rewards()
	else:
		fire_failure()

func fire_rewards():
	for reward in rewards:
		var effect = reward.get_reward()
		rules.callv(
			effect.function, effect.args
		)

func fire_failure():
	for key in units:
		var unit = units[key]
		if unit.allegiance != "player":
			rules.chaos += chaos_per_undefeated
			#unit.faction.gain_research(research_per_undefeated)

func get_objective_task(unit = null):
	var goal = team_goals[unit.allegiance]
	if goal =="killall":
		var enemy
		if unit != null:
			enemy = unit.quadtree.closest_to(units_by_team["coalition"], false).object
		else:
			var rand = randi() % units.size()
			var key = units.keys()[rand]
			enemy = units[key]
		if enemy != null:
			var task = KillTask.new(enemy)
			return task
		else:
			return null
	elif objective == null:
		return null
	elif goal == "destroy":
		var task = DestroyTask.new(objective)
		return task
	elif goal == "steal":
		#Find stealable goods, then make a task to haul them to the depot
		var item = map.find_item_amount_for(data.items.metal, 1, map.active_depot)
		if item != null:
			#_init(newrole, newtarget, newtype, furniture, newitem, newcount)
			var task = GrabTask.new("thief", item.location.position, "fetch", item.location, item, 1)
			task.set_haul(map.active_depot.position, map.active_depot, item, "theft", false)
			item.reserved_count += 1
			return task
		return null
	elif goal == "sabotage":
		#var job = objective.start_job(objective.sabojob, true)
		var task = objective.sabojob.return_task()
		task.reserving = false
		return task
	elif goal == "spy":
		var job = objective.start_job(objective.spyjob, true)
		var task = job.return_task()
		task.reserving = false
		return task
		
func spawn_units():
	for role in unit_lists:
		var list = unit_lists[role]
		pass
	#var squares = map.get_zone_squares("enemydeployment")
	var newunits = get_units("baddies")
	var placedunits = map.place_units_in_zone("enemydeployment", newunits)
	for unit in placedunits:
		add_unit(unit, "baddies")
		
func place_units():
	for role in units_by_role:
		var placement = ""
		if desired_placement.has(role):
			placement = desired_placement[role]
		else:
			placement = "zonespawn"
		var newunits = units_by_role[role]
		if placement == "zonespawn":
			var placedunits = map.place_units_in_zone("enemydeployment", newunits.values())
			pass


func get_units(key):
	#for key in role_factions:
		#if key != "player":
	var faction = role_factions[key]
	var options = lists[key]
	var i = randi() % options.size()
	var chosen = options[i]
	var newunits
	if faction == null:
		faction = rules.factions.coalition
	newunits = faction.generate_units(chosen, -1, roles[key])
		
		
	for unitkey in newunits:
		var unit = newunits[unitkey]
		unit.encounter_role = key
	return newunits
	#for role in unit_lists:
	#	var lists = unit_lists[role]
	#	var rand = randi() % lists.size()
	#	var list = lists[rand]
	#	var units = list.generate_units(roles[role])
	#	return units

func add_squad(squad):
	squads.append(squad)
	for key in squad.units:
		var unit = squad.units[key]
		add_unit(unit, "player")

func assign_unit(unit):
	assigned_units.append(unit)
	add_unit(unit, "player")

func add_unit(unit, role = ""):
	unit.encounter = self
	unit.encounter_role = role
	units.merge({
		unit.id: unit
	})
	units_by_team.merge({
		unit.allegiance: {}
	})
	units_by_team[unit.allegiance].merge({
		unit.id: unit
	})
	units_by_role.merge({
		role: {}
	})
	units_by_role[role].merge({
		unit.id: unit
	})
	for order in orders:
		unit.add_order(order)

func send_units():
	pass

func send_squads():
	for squad in squads:
		rules.transport_order(map)
