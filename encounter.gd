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

var rewards = []

#var goal = "spy"

var bravery = 100000

var objectivetype = ""
var objective

var units = {}

var units_by_team = {}

var team_goals = {}

var enemy_bases = []

#The names of each list used as a base by this encounter
var list_data = {}

#Unit lists keyed by role
var unit_lists = {}

#The Value provided to each role
#This can be made more complex later if desired
var roles = {
	"baddies": 100
}

var orders = []

var zones = {
		#"enemydeployment": [[1,1],[5,5]],
		#"deployment": [[1,6],[7,10]]
	}
	
var type = "mission"

func _init(gamerules, encounterdata):
	var gamedata = gamerules.data
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

func complete_encounter(success):
	squads = []
	fire_rewards()

func fire_rewards():
	for reward in rewards:
		var effect = reward.get_reward()
		rules.callv(
			effect.function, effect.args
		)

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
	var newunits = get_units()
	var placedunits = map.place_units_in_zone("enemydeployment", newunits)
	for unit in placedunits:
		add_unit(unit)


func get_units():
	
	for role in unit_lists:
		var lists = unit_lists[role]
		var rand = randi() % lists.size()
		var list = lists[rand]
		var units = list.generate_units(roles[role])
		return units

func add_squad(squad):
	squads.append(squad)
	for key in squad.units:
		var unit = squad.units[key]
		add_unit(unit)

func add_unit(unit):
	unit.encounter = self
	units.merge({
		unit.id: unit
	})
	units_by_team.merge({
		unit.allegiance: {}
	})
	units_by_team[unit.allegiance].merge({
		unit.id: unit
	})
	for order in orders:
		unit.add_order(order)

func send_squads():
	for squad in squads:
		rules.transport_order(map)
