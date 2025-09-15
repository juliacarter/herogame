@tool
extends Node2D
class_name RuleVars

signal encounter_created(encounter)
signal quest_complete(quest, success)
signal quest_started(quest)

var map

var unitscene = load("res://scene/unit/unit.tscn")

var worldscene = preload("res://test_world.tscn").instantiate()

var aoescene = load("res://cursor_aoe.tscn")

var numscene = load("res://damage_number.tscn")

var popupscene = load("res://float_popup.tscn")

var world

var mainmenu

var deploymaster
var placing_formation = false
var formation_units = []

var known_equipment_by_slot = {
	"head": ["gasmask"],
	"weapon": ["popper", "studder"],
	"armor": ["flakjacket"]
}

@onready var data = get_node("/root/Data")

var active_targeter

@export var scroll = 900
@export var zoom = 0.075

var speed

var interface

var on_interface = false

signal tool_pushed(tool)

var ids = {}

var debugvars = {
	"instabuild": true,
	"unlockall": true,
	"assignanything": true,
	"orderanyone": true,
	"standstill": true,
	"editstats": false,
	"fake_damage": false,
}

var infamy = 000000
var infamy_to_level = 100000

#point bonus for all encounters
var chaos = 0

var mapdistance = 10000.0

var global_queue: Multiqueue

var squaresize = 64

var godpower = "nothing"
var loaded_unit
var loaded_item

var hovered
var selected = {}
var multiselect = {}

var selected_squad

var current_map: Grid
var gridscene = load("res://scene/world/grid.tscn")

var maps = {}
var mapspace = 0
var unusedspaces = []

var scan_progress = 0

var player = Player.new(self)

var waves = {}

var quests = []

var active_arc


#the number of days until the next Arc is rolled for
var arc_days = 1

var arcs = []
var completed_arcs = []

var sell_orders = []

var squads = {}
var classes = {}

var previewing = false
var preview: Preview

var transports = {}

var available_missions = []
var active_missions = {}

#missions to show in the quest list (arcs/threats)
#each Arc gets its own quest list entry, threats are grouped into one entry
var missions = []

var worksites = {}

var workorders = []

#Every unit in the game
var world_units = {}

var unit_id = int(0)

var heat = 100

var daily_heat = 0

var daily_threat = 1

var daytimer = 10

var unitmodels = {"minion": load("res://models/unit_placeholder.tres"), "agent": load("res://models/enemy_placeholder.tres"), "other": load("res://models/unit_placeholder.tres")}

var base_stats = [
	UnitStat.new("Agility", 10),
	UnitStat.new("Strength", 10),
	UnitStat.new("Brains", 10),
	UnitStat.new("Guile", 10),
	UnitStat.new("Charisma", 10),
	UnitStat.new("Attention", 10),
	]
	
var views = {
	"grayedout": GrayedOutView.new("grayedout")
}
	
var current_view: View
	
var base_items = {
	
}

var science
var unlocked = {
	"techs": {},
	"furn": [],
	"upgrades": {},
}

var free_agents = []
var free_agent_refresh_timer = 00.0

var max_free_agents = 5

var home

#faction to spawn new units into
var spawn_faction = "player"

var factions = {
	"coalition": null,
	"player": null,
}

var metajobs = {
	"exfiltrate": null
}

var power

var cursor_aoe

var hovered_waypoint: Waypoint

var dragging

var base_drain = {
	"energy": 0.10,
	#"food": 0.15,
	#"loyalty": 0.20
	"attention": -1.5,
}

var script_map = {
	#Objectives
	"ResourceObjective": ResourceObjective,
	"ResourceSpendObjective": ResourceSpendObjective,
	"EncounterObjective": EncounterObjective,
	"WaveObjective": WaveObjective,
	"ItemSendObjective": ItemSendObjective,
	
	#Conditions
	"StatCondition": StatCondition,
	"MeleeAttackCondition": MeleeAttackCondition,
	"AttackDistanceCondition": AttackDistanceCondition,
	"RandomChanceCondition": RandomChanceCondition,
	
	#Outcomes
	"ApplyBuffOutcome": ApplyBuffOutcome,
	"ActionOutcome": ActionOutcome,
	
	#Rewards
	"CashReward": CashReward,
	"ItemReward": ItemReward,
	"DoomReward": DoomReward,
	
	"Action": Action,
	"Attack": Attack,
	"Spell": Spell,
	
	"SelfSpell": SelfSpell,
	"ToggleSpell": ToggleSpell,
	"SelfAreaSpell": SelfAreaSpell,
	"PlacedAreaSpell": PlacedAreaSpell,
	"LinePlacedAreaSpell": LinePlacedAreaSpell,
	
	#Buffs
	"DoTBuffBase": DoTBuffBase,
	
	#Impacts
	"DamageImpact": DamageImpact,
	"HealImpact": HealImpact,
	"ResistableBuffImpact": ResistableBuffImpact,
	
	"DoomThreat": DoomThreat,
	
	
	"Job": Job,
	"RestJob": RestJob,
	
	"BaseEffect": BaseEffect,
	"ArmorEffect": ArmorEffect,
	"AttackEffect": AttackEffect,
	"DamageOneshot": DamageOneshot,
	
	"Asset": Asset,
	"IntanGenAsset": IntanGenAsset,
}

var job_scripts = {
	"Job": Job,
	"TrainingJob": TrainingJob,
	"RestJob": RestJob,
}

var job_base_scripts = {
	"Job": JobBase,
	"TrainingJob": TrainingJobBase,
	"RestJob": RestJobBase,
}

var indicatorscenes = {
	"AreaEffectCircle": load("res://area_indicator_circle.tscn"),
	"AreaEffectLine": load("res://area_indicator_line.tscn")
}

var colors = {
	"damage": Color.RED
}

var globals = {}
var global_vars = {}

func make_impact(impdata, parent):
	if impdata.has("type"):
		if script_map.has(impdata.type):
			var type = script_map[impdata.type]
			var impact = type.new(impdata, parent)
			return impact
		else:
			print("Invalid impact type!")

func debug_asset():
	make_asset("", world.map.testregion.region)

#make assetname in region
func make_asset(assetname, region):
	var asset = IntanGenAsset.new(self, {})
	asset.faction = factions.player
	region.add_asset(asset)

func change_resolution(width, height):
	get_tree().root.size = Vector2(width, height)
	interface.size = Vector2(width, height)

func aoe_on_unit(aoedata, unit):
	unit.map.aoe_on_unit(aoedata, unit)



func aoe_at_position(caster, pos, aoedata):
	caster.map.aoe_at(aoedata, pos, caster, caster.global_position)

func fire_current_power():
	world.ghostholder.clear_ghosts()
	if power != null:
		power.fire()
		#fire_power(power)

func fire_power(pow):
	current_map.callv(pow.on_cast, pow.cast_args)
	if(!Input.is_action_pressed("queue_ghosts") && pow.panel == ""):
		power = null

func prime_power(new):
	var args = new.get_prime_args()
	callv(new.on_prime, args)

func select_power(new):
	power = new
	#if new is Power:
		#prime_power(new)
	#select(null)
	#interface.update_selection()

func log_entry(logdata):
	pass

func make_soundbubble(bubbledata, pos):
	var popup = popupscene.instantiate()
	popup.global_position = pos
	world.add_child(popup)
	popup.load_soundbubble(bubbledata, pos)

func make_popup(str, pos, color = "damage"):
	var popup = popupscene.instantiate()
	popup.global_position = pos
	var newcolor = colors[color]
	world.add_child(popup)
	popup.load_floattext(str, pos, newcolor)

func select_arc():
	var options = []
	for key in data.arcs:
		#var arc = data.arcs[key]
		if completed_arcs.find(key) == -1:
			options.append(key)
	if options != []:
		var i = randi() % options.size()
		var arcname = options[i]
		start_arc(arcname)

func start_arc(arcname):
	if data.arcs.has(arcname):
		var arcdata = data.arcs[arcname]
		var arc = Arc.new(self, arcdata)
		arc.key = arcname
		arcs.append(arc)
		arc.begin_arc()
		active_arc = arc
		missions.append(arc)
		interface.arcpreview.load_arc(arc)

func complete_arc(arc, success):
	var i = arcs.find(arc)
	if i != -1:
		arcs.pop_at(i)
	var j = missions.find(arc)
	if j != -1:
		missions.pop_at(j)
	completed_arcs.append(arc.key)
	arc_days = randi() % 5
	active_arc = null
	#select_arc()

func perform_research(resname, count):
	pass

func progress_arc_phase(phase, amount):
	phase.progress(amount)

func start_quest(questname, faction = null):
	var questdata = data.quests_to_load[questname]
	var quest = Quest.new(self, questdata)
	#quest.pin = world.map.add_pin(quest.pindata)
	quest.faction = faction
	quests.append(quest)
	quest.start_quest()
	#interface.questlist.load_quests()
	return quest
	
func initial_quests():
	#for key in data.quests_to_load:
	start_quest("domission")
	#interface.questlist.load_quests()
	#start_arc("criminalcaper")
	#select_arc()

func instantiate_class(name_of_class:String, args) -> Object:
	if script_map.has(name_of_class):
		var script := script_map[name_of_class] as GDScript
		if script != null:
			return script.new(args)
	return null

func get_phase_threat():
	if active_arc != null:
		var threat = active_arc.phases[active_arc.current_phase].get_threat()
		if threat != null:
			start_plot(threat, null)

func get_research_threat():
	var potential = []
	for key in factions:
		var faction = factions[key]
		if faction.alignment == "villain":
			potential.append(faction)
	if potential != []:
		var i = randi() % potential.size()
		var selected = potential[i]
		var threat = selected.get_threat()
		#threat.faction = selected
		start_plot(threat, selected)

func roll_chaos_threat():
	if active_arc != null:
		var threat = active_arc.roll_threat("ChaosThreat")
	
func roll_doom_threat():
	if active_arc != null:
		var threat = active_arc.roll_threat("DoomThreat")
	
func roll_special_threat():
	pass

func make_ghost(ghostdata, origin = null):
	var pos = Vector2(0, 0)
	if origin != null:
		pos = origin.global_position
	var ghost = world.ghostholder.make_ghost(ghostdata, origin)

#func roll_threat():
	#var potential = []
	#for key in data.missions:
	#var mission = data.missions[key]
	#	potential.append(mission)
	#var i = randi() % potential.size()
	#var mission = potential[i]
	#start_plot(mission)
	
func start_plot(new, faction):
	var quest = start_quest(new.quest, faction)
	missions.append(new)
	for reward in new.fail_effects:
		quest.fail_effects.append(reward)
		
func finish_plot(plot):
	var i = missions.find(plot)
	if i != -1:
		missions.pop_at(i)

func add_doom_to_phase(phase):
	phase.increase_doom()

func lose_game():
	pass

func fail_quest(quest):
	var i = quests.find(quest)
	#world.map.remove_pin(quest.pin)
	for reward in quest.fail_effects:
		var redata = reward.get_reward()
		callv(redata.function, redata.args)
	if i != -1:
		quests.pop_at(i)
	quest_complete.emit(self, false)
	#interface.questlist.load_quests()

func make_selected_tired():
	for key in selected:
		var unit = selected[key]
		if unit is Unit:
			unit.stats.fuel.add_damage(5)

func complete_quest(quest):
	var i = quests.find(quest)
	#world.map.remove_pin(quest.pin)
	for reward in quest.rewards:
		var redata = reward.get_reward()
		callv(redata.function, redata.args)
	if i != -1:
		quests.pop_at(i)
	quest_complete.emit(self, true)
	
func complete_step(step):
	for reward in step.rewards:
		var redata = reward.get_reward()
		callv(redata.function, redata.args)

func add_intangible(resource, amount):
	player.intangibles[resource] += amount

func time_setting(amount):
	set_time_scale(amount)
	pause(false)

func set_time_scale(amount):
	Engine.time_scale = amount

func pause(setting):
	get_tree().paused = setting


func toggle_pause():
	get_tree().paused = !get_tree().paused

func prime_single_target():
	pass

func prime_targeter(targeter):
	active_targeter = targeter
	callv(targeter.primefunc, targeter.primeargs)

func fire_targeter(targeter):
	var args = [targeter]
	for arg in targeter.targetargs:
		args.append(arg)
	callv(targeter.targetfunc, args)

func change_caster_stat_delta(delta, ability, stat, amount):
	var final = amount * delta
	ability.unit.change_stat(stat, final)

func change_caster_stat(ability, stat, amount):
	ability.unit.change_stat(stat, amount)

func push_away_from_caster(action, victim, amount):
	victim.push_away_from(action.unit.global_position, amount)

func push_away_from_last_attack(action, victim, amount):
	victim.push_away_from(action.last_fire_position, amount)

func effect_on(effect, on):
	await on.defend(Attack.new(self, data.attacks.pistol))

func trigger_dummy():
	pass
	
func kill_selected():
	for key in selected:
		var unit = selected[key]
		if unit is Unit:
			unit.die()
	
#triggered_by: Attack
#triggered_for unused
func percent_bonus_to_damage_total(triggered_by, triggered_for, type, stat, percent, stacks = 1):
	var amount = triggered_by.damage_roll_sum()
	var mult = percent / 100.0
	var bonus = amount * mult
	bonus *= stacks
	triggered_by.add_bonus(type, stat, bonus)
	pass
	
#triggered_by: Attack
#triggered_for unused
func accuracy_for_next_attack(triggered_by, triggered_for, amount):
	triggered_by.bonus_accuracy += amount
	
#triggered_by: Attack
#triggered_for unused
func constant_ap_bonus_to_damage_total(triggered_by, triggered_for, amount):
	triggered_by.bonus_ap += amount

func trigger(trigger_name, triggered_by, triggered_for):
	triggered_for.trigger(trigger_name, triggered_by)

func load_view(view):
	current_view = view
	current_map.load_view(view)

func save():
	var saved_available_missions = []
	var saved_active_missions = []
	var saved_factions = []
	var saved_squads = []
	var saved_npc_squads = []
	for key in available_missions:
		var mission = available_missions[key]
	for key in active_missions:
		var mission = active_missions[key]
	for key in squads:
		var squad = squads[key]
	for key in waves:
		var squad = squads[key]
	var save_dict = {
		"filename" : get_scene_file_path(),
		"scan_progress": scan_progress,
		"daytimer": daytimer,
		"heat": heat,
		"player": player.save,
		"unlocked": unlocked.duplicate(),
		"available_missions": saved_available_missions,
		"active_missions": saved_active_missions,
		"squads": saved_squads,
		"npc_squads": saved_npc_squads
	}
	return save_dict
	
	
func initialize_game():
	free_agent_refresh_timer = 0.0
	generate_free_agents(max_free_agents)
	for key in factions:
		var faction = factions[key]
		faction.initialize()
	
	
func new_game():
	var dir = DirAccess.open("user://")
	dir.make_dir("user://saves")
	dir.make_dir("user://maps")
	get_tree().root.add_child(worldscene)
	world.new_world()
	initialize_game()
	
func new_game_new_map(x, y):
	var dir = DirAccess.open("user://")
	dir.make_dir("user://saves")
	dir.make_dir("user://maps")
	mainmenu.visible = false
	get_tree().root.add_child(worldscene)
	home = await make_map(x, y)
	open_map(home.id)
	initialize_game()
	
func new_game_load_map(path):
	get_tree().root.add_child(worldscene)
	load_map(path)
	initialize_game()
	
func continue_game():
	load_game_prompt()
	open_map(home.id)
	
func load_map_prompt():
	interface.loader.new_game_pick_map()
	
func load_game_prompt():
	interface.loader.load_game_pick_save()
	
func save_game_prompt():
	interface.saver.save_prompt()
	
func save_map_prompt():
	interface.saver.map_prompt()
	
func save_game(filename):
	var path = "user://saves/" + filename + ".motesave"
	var save_game = await FileAccess.open(path, FileAccess.WRITE)
	if save_game == null:
		var error = FileAccess.get_open_error()
		pass
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(json_string)
		pass
		
func save_map(filename):
	var path = "user://maps/" + filename + ".motemap"
	var save_game = FileAccess.open(path, FileAccess.WRITE)
	if save_game == null:
		var error = FileAccess.get_open_error()
		pass
	var save_nodes = get_tree().get_nodes_in_group("PersistMap")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(json_string)
		pass
		
func load_map(path):
	if not FileAccess.file_exists(path):
		return # Error! We don't have a save to load.
	
	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	#var save_nodes = get_tree().get_nodes_in_group("PersistMap")
	#for i in save_nodes:
	#	i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_game = FileAccess.open(path, FileAccess.READ)
	var added_maps = {}
	var added_units = {}
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instantiate()
		if !new_object is RuleVars:
			
			new_object.data = data
			new_object.rules = self
			#await new_object.load_save(node_data)
			#world.add_child(new_object)
				
			if new_object is Grid:
				added_maps.merge({node_data: new_object})
			elif new_object is Unit:
				added_units.merge({node_data: new_object})
		else:
			scan_progress = node_data.scan_progress
			daytimer = node_data.daytimer
			heat = node_data.heat
			unlocked = node_data.unlocked.duplicate()
			player.load_save(node_data.player)
			
			for missiondata in node_data.active_missions:
				#var mission = Encounter.new()
				start_mission(missiondata)
			
			for missiondata in node_data.available_missions:
				pass
				#var mission = Encounter.new()
				#available_missions.append(mission)
	for mapdata in added_maps:
		var map = added_maps[mapdata]
		map.id = uuid(map)
		#world.add_child(map)
		
		await map.load_saved_map(mapdata)
		await add_map(map)
		if current_map == null:
			open_map(map.id)
		await map.generate_cells()
	for mapdata in added_maps:
		var map = added_maps[mapdata]
		await map.load_saved_furniture(mapdata.furniture, false)
	for mapdata in added_maps:
		var map = added_maps[mapdata]
		await map.load_footprints(mapdata.blocks)
	for mapdata in added_maps:
		var map = added_maps[mapdata]
		await map.load_floorstacks(mapdata)
	return added_maps.values()[0]
		
# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game(path):
	if not FileAccess.file_exists(path):
		return # Error! We don't have a save to load.
	get_tree().root.add_child(worldscene)
	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_game = FileAccess.open(path, FileAccess.READ)
	var added_maps = {}
	var added_units = {}
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instantiate()
		new_object.data = data
		new_object.rules = self
		#await new_object.load_save(node_data)
		#world.add_child(new_object)
			
		if new_object is Grid:
			added_maps.merge({node_data: new_object})
		elif new_object is Unit:
			added_units.merge({node_data: new_object})
	for mapdata in added_maps:
		var map = added_maps[mapdata]
		await map.load_saved_map(mapdata)
		add_map(map)
	for mapdata in added_maps:
		var map = added_maps[mapdata]
		await map.load_saved_furniture(mapdata.furniture, true)
	for mapdata in added_maps:
		var map = added_maps[mapdata]
		await map.load_footprints(mapdata.blocks)
	for mapdata in added_maps:
		var map = added_maps[mapdata]
		await map.load_floorstacks(mapdata)
	for unitdata in added_units:
		var unit = added_units[unitdata]
		await unit.load_save(unitdata)
		unit.process_mode = 1
		await world.add_unit(unit)
	#for unitdata in added_units:
		#var unit = added_units[unitdata]
		#await unit.load_tasks(unitdata)
	#for mapdata in added_maps:
		#var map = added_maps[mapdata]
		#await map.load_taskmaster(mapdata)
			

			#"squads": saved_squads,
			#"npc_squads": saved_npc_squads

func save_and_quit(filename):
	await save_game(filename)
	get_tree().quit()

func save_map_and_quit(filename):
	await save_map(filename)
	get_tree().quit()

func hover_waypoint(waypoint):
	hovered_waypoint = waypoint
	
func start_waypoint_drag():
	if hovered_waypoint != null:
		dragging = hovered_waypoint
		
func stop_drag():
	dragging = null

func get_classes():
	var newclasses = classes.duplicate()
	return newclasses

func fire_ability(instance):
	instance.base.fire(instance)

func send_units(units, destination):
	for unit in units:
		var transport = Transport.new(self)
		transport.queue_transit({unit.id: unit}, destination)
		transport.id = assign_id(transport)
		transports.merge({
			transport.id: transport
		})
		#unit.queue_transit(destination)
		
func send_units_grouped(units, destination):
	var transport = Transport.new(self)
	var newunits = {}
	for unit in units:
		newunits.merge({
			unit.id: unit
		})
	transport.queue_transit(newunits, destination)
	transport.id = assign_id(transport)
	transports.merge({
		transport.id: transport
	})

func _physics_process(delta):
	if cursor_aoe != null:
		cursor_aoe.global_position = get_global_mouse_position()
	for key in transports:
		var transport = transports[key]
		if transport.moving:
			if transport.travel(delta):
				transports.erase(transport)
	for key in active_missions:
		var mission = active_missions[key]
		if mission is MapJob:
			mission.think(delta)
	var neworders = []
	for order in workorders:
		await order.make_tasks()
		if order.count > 0 || order.waiting_jobs.size() > 0:
			neworders.append(order)
	for i in sell_orders.size():
		var order = sell_orders[i]
		var done = order.check_items()
		if done:
			sell_orders.pop_at(i)
	for quest in quests:
		quest.think(delta)
		quest.check_quest()
	for key in waves:
		var wave = waves[key]
		wave.think(delta)
	for key in waves:
		var squad = waves[key]
		squad.think(delta)
	if data != null:
		free_agent_time(delta)
		free_agent_refresh_timer -= delta
		if free_agent_refresh_timer <= 0:
			generate_free_agents(1)
			free_agent_refresh_timer = float(randi() % 120)
	workorders = neworders
	if world != null:
		daytimer -= delta
		if daytimer <= 0:
			calculate_day()

func free_agents_updated():
	if interface != null:
		if interface.windows.has("freeagent"):
			interface.windows.freeagent.current_tab.load_free_agents()

func free_agent_time(delta):
	for i in range(free_agents.size()-1,-1,-1):
		var agent = free_agents[i]
		agent.time -= delta
		if agent.time <= 0:
			free_agents.pop_at(i)
			free_agents_updated()
			

func hire_class(newclass):
	if newclass.prospect != "":
		var unit = hire_prospect(newclass.prospect)
		if unit != null:
			unit.change_class(newclass)

func hire_prospect(prospect):
	if data.wizards.unit.has(prospect):
		var wizard = data.wizards.unit[prospect]
		var unit = wizard.generate_unit(-1, false, false).unit
		unit.set_faction(factions.player)
		home.place_unit(unit, home.get_entry().global_position)
		#if allegiance == "player":
		unit.add_clearance(3)
		return unit

func hire_agent(agent):
	var i = free_agents.find(agent)
	var unit = agent.unit
	if i != -1:
		free_agents.pop_at(i)
		unit.set_faction(factions.player)
		home.place_unit(unit, home.get_entry().global_position)
		pass

func generate_free_agents(count):
	if free_agents.size() < max_free_agents:
		for i in count:
			var unit = data.wizards.unit.agent.generate_unit().unit
			new_free_agent(unit)
		free_agents_updated()
	
func new_free_agent(unit):
	var time = (randi() % 30) + 30.0
	var agent = FreeAgent.new(unit, time)
	free_agents.append(agent)

func complete_wave(wave):
	waves.erase(wave.id)

func scan_squares():
	current_map.dragbox.detect_squares()
	pass
	
func scan_units():
	current_map.dragbox.detect_units()

func spend_upkeep():
	for key in factions.player.units:
		var unit = factions.player.units[key]
		for upkey in unit.base_upkeep:
			var count = unit.base_upkeep[upkey]
			if player.spend_intangible(upkey, count):
				pass
			else:
				unit.upkeep_failed(upkey)

func calculate_day():
	daytimer = 10
	if arc_days > 0 && active_arc == null:
		arc_days -= 1
	spend_upkeep()
	#elif active_arc == null:
		#select_arc()
	#get_phase_threat()
	#calculate_wave()
	
func calculate_wave():
	var wave = factions.coalition.select_wave()
	if wave != null:
		spawn_wave("coalition", wave)
		factions.coalition.heat -= wave.heatcost
	else:
		factions.coalition.heat += daily_heat
		
func master_death(master):
	var best
	var bestdist = 0
	for key in home.lifepods:
		var furn = home.lifepods[key]
		if !furn.dead:
			var distance = master.global_position.distance_squared_to(furn.global_position)
			if distance > bestdist:
				best = furn
				bestdist = distance
	if best != null:
		best.save_master(master)
	else:
		#GAME ENDS IF MASTER DIES WITH NO LIFEPOD
		pass
		
func generate_wave():
	pass

func _ready():
	#load_game()
	#get_tree().root.add_child(worldscene)
	player.science = Science.new(self, data)
	
	for base in data.items:
		var item = data.items.get(base)
		item.id = uuid(item)
	for key in data.classes:
		var newclass = data.classes[key]
		newclass.id = uuid(newclass)
		classes.merge({
			newclass.id: newclass
		})
		

		
func apply_self_buff(caster, target, buffname, amount):
	var buff = data.buffs[buffname]
	caster.apply_buff(buff)
		
func apply_buff(caster, target, buffname, amount):
	var buff = data.buffs[buffname]
	target.apply_buff(buff)

func grant_status_buildup(granter, target, status, amount):
	target.status_buildup(status, amount)

func unlock_stuff(stuff):
	for key in stuff.techs:
		var tech = data.techs[key]
		unlocked.techs.merge({
			key: tech
		}, true)
	for furn in stuff.furn:
		if data.furniture.has(furn):
			unlocked.furn.append(furn)
			data.furniture[furn].unlocked = true
	for lesson in stuff.upgrades:
		unlocked.upgrades.append(lesson)
		
func add_map(map):
	map.world = world
	maps.merge({
		map.id: map
	})
	if unusedspaces != []:
		map.spacing = unusedspaces.pop_front()
	else:
		map.spacing = mapspace
		mapspace += 1
	map.global_position = Vector2(mapdistance * map.spacing, 0)
	await world.load_map(map)
	await map.generate_cells()
	map.load_squares()
	if interface != null:
		interface.maptabs.load_maps()
	#if current_map == null:
	#	open_map(map.id)
	if home == null:
		home = map
	return map
		
func start_scheme(schemename, region):
	if data.schemes.has(schemename):
		region.scheme_active = true
		var scheme = data.schemes[schemename]
		var quest = start_quest(scheme.quest)
		quest.region = region
		
func make_base_in_region(new):
	var map = await make_map(10, 10)
		
func make_map(x, y):
	var map = gridscene.instantiate()
	map.x = x
	map.y = y
	
	map.id = uuid(map)
	#map.load_squares()
	return await add_map(map)
	
func open_world_map():
	close_map()
	world.map.visible = true
	camera_to(world.map.global_position)

func close_world_map():
	world.map.visible = false
	
func open_map(mapid):
	close_world_map()
	if current_map != null:
		current_map.viewed = false
	current_map = maps[mapid]
	current_map.visible = true
	current_map.viewed = true
	camera_to(current_map.blocks[0][0].global_position)
	
func close_map():
	if current_map != null:
		current_map.visible = false
		current_map.viewed = false
	
func remove_map(mapid):
	if maps.has(mapid):
		var map = maps[mapid]
		world.remove_map(map)
		maps.erase(mapid)
		if interface != null:
			interface.maptabs.close_tab(map)
		if current_map.id == mapid:
			open_map(maps.keys()[0])
	
func transfer_unit(unit, map, placed = false):
	if unit.map != null:
		if unit.map != map:
			unit.map.remove_unit(unit)
	unit.map = map
	unit.halt()
	unit.stored = false
	unit.spawned = false
	var entry = map.get_entry()#.get_movement(null)
	if !placed:
		await map.place_unit(unit, entry.global_position)
	pass
	
func change_target_unit_stat(target, stat, amount):
	target.change_stat(stat, amount)
	
func camera_to(newposition):
	world.camera.global_position = newposition
	
func new_class():
	var newclass = UnitClass.new({
		"name" : "New",
		"selectable": true,
		"roles": {},
		"aggro": false,
	})
	newclass.id = assign_id(newclass)
	save_class(newclass)
	return newclass
	
func save_class(newclass):
	classes.merge({
		newclass.id: newclass
	}, true)

func select_squad(squad):
	select_multiple(squad.units)
	selected_squad = squad
	interface.update_selection()
	
func select(object):
	selected = {}
	selected_squad = null
	if object != null:
		selected.merge({object.id: object})
	interface.update_selection()
	
func select_multiple(multi):
	selected = {}
	var squadded = true
	var multisquad = null
	for key in multi:
		var object = multi[key]
		if object.squad == multisquad || multisquad == null:
			multisquad = object.squad
		else:
			squadded = false
		selected.merge({object.id: object})
	if squadded:
		selected_squad = multisquad
	else:
		selected_squad = null
	interface.update_selection()
	
func add_select(object):
	selected.merge({object.id: object})
	interface.update_selection()

func move_order(square, final, queued = false):
	for key in selected:
		var object = selected[key]
		if object.entity() == "UNIT":
			object.move_order(square, final, queued)
	
func spawn_unit(unit):
	godpower = "spawn"
	loaded_unit = data.units.get(unit)
	
func spawn_item(item):
	godpower = "item"
	loaded_item = data.items.get(item)
	
func grab_tile():
	unpreview()
	godpower = "flip"
	print("grab tile")
	
func clear():
	unpreview()
	godpower = "normal"
	
func furni_panel():
	print("furni panel")

func research_tech(tech):
	science.research_tech(tech)

func modify_resource(resource, amount):
	pass
	
func add_cash(amount):
	player.intangibles.cash += amount
	
func unpreview():
	current_map.clear_preview()

func preview_tile(tiledata):
	print(data)
	godpower = "tile"
	print(godpower)
	previewing = true
	print(previewing)
	current_map.preview_tile(tiledata)
	print("preview activated")
	
func grab_preview(data, caster = null):
	print(data)
	godpower = "furniture"
	print(godpower)
	previewing = true
	print(previewing)
	current_map.activate_preview(data)
	print("preview activated")
	
func open_view_for(object):
	if object is Unit:
		interface.open_character_sheet(object)
	
func uuid(object):
	unit_id += 1
	ids.merge({
		unit_id: object
	})
	return String.num(unit_id)

func opportunity_scan(amount):
	scan_progress += amount
	if scan_progress > 3.0:
		draw_encounter()
		
func progress_objective(objective, count):
	objective.completions += count
		
func draw_encounter():
	var encounter = Encounter.new(self, data.encounters.skirmish)
	#encounter.unit_lists.baddies = [data.lists.unit.agents]
	encounter.rules = self
	#encounter.goal = "killall"
	encounter.enemy_bases = [
		data.units.agent,
		data.units.agent,
		data.units.agent
	]
	
	encounter.id = assign_id(encounter)
	available_missions.append(
		encounter
	)
	
func draw_mapjob():
	var job = MapJob.new(self, data.mapjobs.peprally)
	job.rules = self
	job.id = uuid(job)
	available_missions.append(job)
	
func make_toast(text, pos):
	var toastdata = {"text": text, "location": pos}
	interface.toastbar.make_toast(toastdata)
	
func buy_shop_item(base, count):
	home.generate_item(base, count)
	
func buy_shop_quest(questname, count):
	start_quest(questname)
	interface.questlist.load_quests()
	
func sell_shop_item(base, count):
	var order = SellOrder.new(self)
	order.order_item(base, count)
	sell_orders.append(order)
	
func send_quest_item(base, count, objective):
	var order = QuestSendOrder.new(self, objective)
	order.order_item(base, count)
	sell_orders.append(order)
	
func start_missiongroup(mishname):
	var missiondata = data.missions[mishname]
	var mission = Mission.new(self, missiondata)
	available_missions.append(mission)
	
func start_encounter(encounter, faction = null):
	encounter.encounter_complete.connect(end_encounter)
	encounter.id = assign_id(encounter)
	#if encounter.quest != null:
		#encounter.quest.started = true
	world.map.add_location(encounter)
	encounter.role_factions.player = factions.player
	encounter.role_factions.baddies = faction
	available_missions.append(encounter)

func end_encounter(encounter, success):
	var i = available_missions.find(encounter)
	if i != -1:
		available_missions.pop_at(i)

func selected_controllable():
	if debugvars.orderanyone:
		return true
	var result = true
	for key in selected:
		var object = selected[key]
		if !object is Unit:
			result = false
		else:
			result = player.innercircle.has(object.id) || (object == player.master)
	return result

func spawn_item_at_depot(item, count):
	#var base = data.items[item]
	home.active_depot.depot_order(item, count, true)

func buy_entry(entry, count):
	for key in entry.prices:
		var cost = entry.prices[key] * count
		player.intangibles[key] -= cost
	var args = entry.purchase_args.duplicate()
	args.push_back(count)
	callv(entry.on_purchase, args)
	
func sell_entry(entry, count):
	pass

func start_mission_by_name(missionname):
	if data.quests_to_load.has(missionname):
		var mission = data.quests_to_load[missionname]
		start_mission(mission)

func new_encounter_by_name(encname):
	var encounterdata = data.encounters[encname]
	var enc = Encounter.new(self, encounterdata)
	enc.key = encname
	enc.enemy_bases = [
		data.units.agent,
		data.units.agent,
		data.units.agent
	]
	enc.rules = self
	enc.return_map = home
	encounter_created.emit(enc)
	return enc

func start_mission(mission):
	active_missions.merge({
		mission.id: mission
	})
	var mission_map = await load_map("user://maps/" + mission.mapname + ".motemap")
	mission_map.encounter = mission
	mission.map = mission_map
	if mission.quest != null:
		mission.quest.started = true
	mission.make_zones()
	#mission.spawn_units()
	#mission.map.spawn_unit_blob(mission.enemy_bases)
	var units = []
	for unit in mission.assigned_units:
		#var unit = mission.units[key]
		units.append(unit)
	#for squad in mission.squads:
		#for key in squad.units:
			#var unit = squad.units[key]
			#units.append(unit)
	if mission is Encounter:
		mission.role_factions.baddies = factions.coalition
		mission.generate_encounter()
		mission.start_encounter()
		send_units_grouped(units, mission_map)
		mission.send_squads()
	else:
		send_units(units, mission_map)
	return mission
		#mission.transport = squad.transport_order(mission_map)

func start_mission_skip_send(mission):
	active_missions.merge({
		mission.id: mission
	})
	var mission_map = await load_map("user://maps/" + mission.mapname + ".motemap")
	mission_map.encounter = mission
	mission.map = mission_map
	if mission.quest != null:
		mission.quest.started = true
	mission.make_zones()
	#mission.spawn_units()
	#mission.map.spawn_unit_blob(mission.enemy_bases)
	var units = []
	for unit in mission.assigned_units:
		#var unit = mission.units[key]
		units.append(unit)
	#for squad in mission.squads:
		#for key in squad.units:
			#var unit = squad.units[key]
			#units.append(unit)
	if mission is Encounter:
		mission.role_factions.baddies = factions.coalition
		mission.generate_encounter()
		mission.start_encounter()
		#send_units_grouped(units, mission_map)
		#mission.send_squads()
	#else:
		#send_units(units, mission_map)
	return mission
		#mission.transport = squad.transport_order(mission_ma

func start_map_job(mission):
	active_missions.merge({
		mission.id: mission
	})
	worksites.merge({
		mission.id: mission
	})
	if interface != null:
		interface.maptabs.load_maps()
	var units = []
	for squad in mission.squads:
		for key in squad.units:
			var unit = squad.units[key]
			units.append(unit)
	send_units(units, mission)

func start_placement(units, map, mission):
	formation_units = units.duplicate()
	interface.placementbutton.visible = true
	placing_formation = true
	deploymaster = DeployMaster.new(map, mission)
	deploymaster.rules = self
	open_map(map.id)
	interface.update_selection()
	get_tree().paused = true
	#map.start_placement(units, mission)



func pop_formation_unit():
	var key = formation_units.keys()[0]
	var unit = formation_units[key]
	formation_units.erase(key)
	current_map.place_unit(unit, current_map.blocks[current_map.highlighted.x][current_map.highlighted.y].global_position)
	transfer_unit(unit, current_map, true)
	if formation_units.is_empty():
		finish_placement()
		
func place_selected_formation_unit():
	if selected.size() == 1:
		var square = current_map.blocks[current_map.highlighted.x][current_map.highlighted.y]
		if square.zones.has("deployment"):
			var unit = selected.values()[0]
			if !unit.deployed:
				unit.deployed = true
				formation_units.erase(formation_units.values().find(unit))
				transfer_unit(unit, current_map, true)
				current_map.place_unit(unit, square.global_position)
				pass

func check_placement_finished():
	var done = true
	for key in formation_units:
		var unit = formation_units[key]
		if unit.map != current_map:
			done = false
	if done:
		finish_placement()

func finish_placement():
	deploymaster.execute_plans()
	placing_formation = false
	interface.placementbutton.visible = false
	get_tree().paused = false

func make_unit(unitdata):
	var unit = unitscene.instantiate()
	unit.data = data
	unit.load_data(self, data, unitdata)
	unit.id = assign_id(unit)
	return unit

func spawn_wave(wavedata, factionkey = "coalition", objective = "default"):
	make_toast("wave", home.active_port.global_position)
	if factions.has(factionkey):
		var faction = factions[factionkey]
		var wave = Wave.new(data, wavedata)
		wave.map = home
		if objective != "default":
			wave.team_goals.merge({factionkey: objective}, true)
		start_wave(wave, factionkey)
		
func start_wave(wave, factionkey):
	var faction = factions[factionkey]
	var list = wave.get_units()
	var units = []
	for unit in list:
		unit.set_faction(faction)
		unit.allegiance = factionkey
		wave.add_unit(unit)
		world.add_child(unit)
		unit.encounter = wave
			
	wave.data = data
	wave.rules = self
	wave.id = uuid(wave)
	waves.merge({
		wave.id: wave
	})
	
	home.spawn_wave(wave)
	
func remove_squad(squad):
	squads.erase(squad.id)
	
func new_squad():
	var squad = Squad.new()
	squad.data = data
	squad.rules = self
	squad.id = uuid(squad)
	squads.merge({
		squad.id: squad
	})
	interface.squadtabs.load_squads(squads)
	#interface.windows.units.views.squads.get_options()
	return squad
	
func make_selection_squad():
	if selected != {}:
		var squad = Squad.new()
		squad.data = data
		squad.rules = self
		squad.id = uuid(squad)
		squads.merge({
			squad.id: squad
		})
		for key in selected:
			var object = selected[key]
			if object.entity() == "UNIT":
				if squad.leader == null:
					squad.leader = object
				if object.squad != null:
					object.squad.remove_unit(object)
				squad.add_unit(object)
		interface.squadtabs.load_squads(squads)
	
	
func add_selection_to_squad(squad):
	if selected != {}:
		for key in selected:
			var object = selected[key]
			if object.entity() == "UNIT":
				if object.squad != null:
					object.squad.remove_unit(object)
				squad.add_unit(object)
				interface.squadtabs.load_squads(squads)
	
func sort(a, b, n):
	copy_array(a, 0, n, a)
	top_down_split_merge(a, 0, n, a)
	
func top_down_split_merge(b, iBegin, iEnd, a):
	if (iEnd - iBegin <= 1):                
		return;                                 
	var iMiddle = (iEnd + iBegin) / 2
	top_down_split_merge(a, iBegin, iMiddle, b)
	top_down_split_merge(a, iMiddle, iEnd, b)
	top_down_merge(b, iBegin, iMiddle, iEnd, a)
	
func top_down_merge(b, iBegin, iMiddle, iEnd, a):
	var i = iBegin
	var j = iMiddle
 
	for k in range(iBegin, iEnd):
		if (i < iMiddle && (j >= iEnd || a[i] <= a[j])):
			b[k] = a[i]
			i = i + 1;
		else:
			b[k] = a[j]
			j = j + 1;

func prime_spell(spell):
	power = spell
	active_targeter = spell.targeter

func start_casting():
	pass
	
func stop_casting():
	remove_aoe()
	
func make_aoe(shapename, radius):
	stop_casting()
	cursor_aoe = aoescene.instantiate()
	cursor_aoe.make_shape(shapename, radius)
	add_child(cursor_aoe)
	
func remove_aoe():
	if cursor_aoe != null:
		cursor_aoe.remove_shape()
		remove_child(cursor_aoe)
		cursor_aoe = null
		

func get_picker_equipment_options(slotname):
	var result = []
	for item in known_equipment_by_slot[slotname]:
		var itemdata = data.items[item]
		result.append(itemdata)
	return result
	
func get_selected():
	if selected == {}:
		return null
	if selected.size() == 1:
		return selected.values()[0]
	else:
		return selected.values()

func get_picker_options(slot):
	if slot == "criteria":
		return [
			AggressionCriteria.new(),
			ClassCriteria.new()
		]
	if slot == "classes":
		var result = []
		for key in classes:
			var newclass = classes[key]
			result.append(newclass)
		return result
	if slot == "units":
		var result = []
		for key in world_units:
			var unit = world_units[key]
			if unit.allegiance == "player":
				result.append(unit)
		return result
	if slot == "order":
		return [
			ClearanceOrder.new()
		]
	if slot == "lesson":
		var result = []
		for key in data.upgrades:
			var lesson = data.upgrades[key]
			if lesson.type == "lesson":
				result.append(lesson)
		return result
	if slot == "assets":
		var result = []
		for key in data.assets:
			result.append(key)
		return result
	if slot == "augment":
		var result = []
		for key in data.upgrades:
			var lesson = data.upgrades[key]
			if lesson.type == "augment":
				result.append(lesson)
		return result

func open_category(category):
	selected = {
		category.catname: category
	}
	interface.update_selection()

func copy_array(a, iBegin, iEnd, b):
	for k in range(iBegin, iEnd):
		b[k] = a[k]
		
func hover(object):
	if hovered != null:
		hovered.highlight.visible = false
	hovered = object
	if hovered != null:
		hovered.highlight.visible = true

func assign_id(object):
	if object.id != null && object.id != "":
		if int(object.id) > int(unit_id):
			unit_id = int(object.id)
		ids.merge({
			object.id: object
		})
		return object.id
	else:
		object.id = uuid(object)
		return object.id
