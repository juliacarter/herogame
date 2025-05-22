@tool
extends Node2D
class_name Grid

#var thread: Thread

var id

var global_queue: Multiqueue

var zonescene = load("res://zone.tscn")

var world

var tab

@onready var rules = get_node("/root/WorldVariables")
@onready var data = get_node("/root/Data")

var floorstacks = []

var dragbox

signal navigate(pos)

var blocks: Array
@export var x = 10:
	set(new_x):
		x = new_x
@export var y = 10:
	set(new_y):
		y = new_y
		
var navmap: RID
var squarescene = preload("res://scene/world/square.tscn")
var unitscene = preload("res://scene/unit/unit.tscn")
var blockscene = preload("res://scene/world/block.tscn")
var wallscene = preload("res://scene/world/wall.tscn")
var floorscene = preload("res://scene/world/floor.tscn")
var furniturescene = preload("res://scene/furniture/furniture.tscn")
var previewscene = load("res://scene/furniture/preview.tscn")
var cursorscene = preload("res://scene/world/cursor.tscn")
var itemscene = preload("res://scene/item/stack.tscn")
var beamscene = preload("res://attack_beam.tscn")
var dragscene = preload("res://drag_box.tscn")
var waypointscene = preload("res://waypoint.tscn")

var tilepreviewscene = preload("res://tile_previewer.tscn")

var visualscenes = {
	"ActionAnimationBeam": preload("res://attack_beam.tscn"),
	"ActionAnimationProjectile": preload("res://action_animation_projectile.tscn"),
	"VisualEffectSprite": preload("res://visual_effect_sprite.tscn")
}

var aoescene = load("res://area_effect.tscn")

var aoescenes = {
	"AreaEffectCircle": load("res://area_effect_circle.tscn"),
	"AreaEffectLine": load("res://area_effect_line.tscn")
}

var unittree: QuadTree
var furntree: QuadTree
var itemtree: QuadTree

var preview

var tilepreview


var cursor

var power = 0
var consumed_power = 0

var camerapower = 0
var consumed_camerapower = 0

var prisons = {}

var furniture = {}

var furniture_by_priority = []

var furniture_by_heat = {}

var loaded_furniture = []
var loaded_jobs = []
var loaded_waypoints = []

var jobs = {}

var training_jobs = {}

#jobs waiting to be started
var waiting_jobs = {}

var active_jobs = {}
var active_lessons = {}

#DEBUG
var jobs_completed = {}
var jobs_ordered = {}
var jobs_getstuff = {}

var waypoints = {}

var patrols = []

var patrols_by_priority = {}

var teachers = {}

var trainers = {}

var containers = {}
var restores = {}
var objectives = {}
var accessories = {}
var lifepods = {}

var cameras = {}

var active_depot
var active_port

var stacks = {}

var units = {}
var units_by_role = {}

var squads = {}

var zones = {}

var active = true
var viewed = false

var completed = false

var highlighted = {"x": 1, "y": 1}
var current: Square

var spacing = 0

var taskmaster: Taskmaster

var entry: Square

var encounter: Encounter

var visuals = {
	
}

func generate_item(base, count):
	if active_depot != null:
		active_depot.depot_fill(base, count)

func save():
	var saved_zones = []
	var saved_stacks = []
	var saved_furniture = []
	var saved_waypoints = []
	var saved_blocks = []
	for key in zones:
		var zone = zones[key]
		saved_zones.append(zone.save())
	for key in stacks:
		var basearray = stacks[key]
		for stack in basearray:
			saved_stacks.append(stack.save())
	for key in furniture:
		var furn = furniture[key]
		saved_furniture.append(furn.save())
	for key in waypoints:
		var waypoint = waypoints[key]
		saved_waypoints.append(waypoint.save())
	for i in blocks.size():
		saved_blocks.append([])
		for j in blocks[i].size():
			var square = blocks[i][j]
			saved_blocks[i].append(square.save())
	var save_dict = {
		"filename" : get_scene_file_path(),
		"id": id,
		"size": {"x": x, "y": y},
		"taskmaster": taskmaster.save(),
		"zones": saved_zones,
		"stacks": saved_stacks,
		"spacing": spacing,
		"furniture": saved_furniture,
		"waypoints": saved_waypoints,
		"blocks": saved_blocks,
	}
	if encounter != null:
		save_dict.merge({
			"encounter": encounter.save()
		})
	return save_dict

func load_saved_map(savedata):
	#id = savedata.id
	rules.assign_id(self)
	spacing = savedata.spacing
	rules.ids.merge({
		id: self
	})
	x = savedata.size.x
	y = savedata.size.y
	for i in savedata.blocks.size():
		var row = savedata.blocks[i]
		blocks.append([])
		for j in savedata.blocks.size():
			var squaredata = savedata.blocks[i][j]
			var square = squarescene.instantiate()
			square.rules = rules
			square.data = data
			square.load_save(squaredata)
			blocks[i].append(square)
	await place_squares()

func load_squares():
	for n in x:
		var row = Array()
		for m in y:
			# var squareScene: Square
			var square = squarescene.instantiate()
			var block: Block
			square.set_content(data.blocks_to_load.grass)
			square.set_pos(n, m)
			# square.add_child(block)
			row.append(square)
			
		
		blocks.append(row)

func place_squares():
	for n in x:
		for m in y:
			if m > 0:
				blocks[n][m].n = blocks[n][m-1]
				blocks[n][m-1].s = blocks[n][m]
			if n > 0:
				blocks[n][m].w = blocks[n-1][m]
				blocks[n-1][m].e = blocks[n][m]
			if n > 0 && m > 0:
				blocks[n][m].nw = blocks[n-1][m-1]
				blocks[n-1][m].ne = blocks[n][m-1]
				
				blocks[n-1][m-1].se = blocks[n][m]
				blocks[n][m-1].sw = blocks [n-1][m]
			var square = blocks[n][m]
			add_child(square)
			square.position = Vector2((rules.squaresize * n), (rules.squaresize * m))
			if n == 0 || m == 0 || n == x - 1 || m == y - 1:
				square.to_edge()
	
	return

func generate_cells():
	for n in range(1, x-1):
		for m in range(1, y-1):
			pass
			await blocks[n][m].assign_cells()

func load_saved_furniture(savedfurn, resuming):
	await place_squares()
	for furndata in savedfurn:
		var furn = await load_furniture(furndata, resuming)
		rules.assign_id(furn)
		if furn != null:
			loaded_furniture.append(furn)
			rules.ids.merge({
				furn.id: furn
			})
		else:
			print("Failed to load furniture!")

func load_footprints(blockdata):
	for i in blockdata.size():
		for j in blockdata[i].size():
			var contentdata = blockdata[i][j].content
			if contentdata.type == "footprint":
				var furnid = contentdata.content
				if rules.ids.has(furnid):
					blocks[i][j].content = rules.ids[furnid]
					
					
func load_taskmaster(masterdata):
	pass

func load_floorstacks(savedstacks):
	for stackdata in savedstacks:
		pass

func load_save(savedata):
	taskmaster = Taskmaster.new()
	taskmaster.rules = rules
	taskmaster.load_save(savedata.taskmaster)
	for zonedata in savedata.zones:
		var zone = zonescene.instantiate()
		zone.map = self
		zone.data = data
		zone.rules = rules
		zone.load_save(zonedata)
	for stackdata in savedata.stacks:
		var stack = itemscene.instantiate()
		stack.map = self
		stack.rules = rules
		stack.load_save(stackdata)
	
	for pointdata in savedata.waypoints:
		load_waypoint(pointdata)
	
	if savedata.has("encounter"):
		#var encounter = Encounter.new()
		encounter.load_save(savedata.encounter)
			
func load_ids(savedata):
	#taskmaster.load_ids(savedata.taskmaster)
	for furndata in savedata.furniture:
		var furn = furniture[furndata.id]
		furn.load_ids(furndata)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var w = x * rules.squaresize * 1.0
	var h = y * rules.squaresize * 1.0
	var center = Vector2(w/2.0, h/2.0) + Vector2(spacing * 10000, 0)
	unittree = QuadTree.new(center, {"w": w, "h": h}, 0, null, "unit")
	furntree = QuadTree.new(center, {"w": w, "h": h}, 0, null, "furniture")
	itemtree = QuadTree.new(center, {"w": w, "h": h}, 0, null, "item")
	taskmaster = Taskmaster.new()
	taskmaster.rules = rules
	taskmaster.map = self
	call_deferred("nav_setup")
	furniture = {}
	preview = previewscene.instantiate()
	tilepreview = tilepreviewscene.instantiate()
	cursor = cursorscene.instantiate()
	dragbox = dragscene.instantiate()
	add_child(dragbox)
	#preview.add_furniture(null)
	#preview.z_index = 20
	preview.visible = false
	
	add_child(cursor)
	add_child(preview)
	add_child(tilepreview)
	
	if blocks.size() == 0:
		load_squares()
	place_squares()
	make_evac_zone()
	#rules.open_map(id)
	

func visual_effect(effect, caster = null, target = null):
	if effect.type != "SELF" && effect.type != "TARGET":
		var scene = effect.type
		var beam = visualscenes[scene].instantiate()
		#beam.map = self
		#visuals.merge({
		#	beam: true
		#})
		add_child(beam)
		beam.load_animation(effect)
		beam.cast(caster, target)
		#remove_child(beam)

func set_queue(queue):
	global_queue = queue

func nav_setup():
	navmap = get_world_2d().get_navigation_map()
	print(navmap)
	NavigationServer2D.map_set_active(navmap, true)
	NavigationServer2D.map_set_edge_connection_margin(navmap, 12.0)
	NavigationServer2D.map_set_cell_size(navmap, 4.0)
	NavigationServer2D.map_force_update(navmap)
	print("Margin:" + String.num(NavigationServer2D.map_get_edge_connection_margin(navmap)))
	print("Cell Size:" + String.num(NavigationServer2D.map_get_cell_size(navmap)))
	
func get_square(pos):
	pass
	
func get_ring(x, y, radius):
	pass

#func _input(event):
	#pass
	
func aoe_at(aoedata, pos, caster = null, origin = null):
	var aoe
	if aoedata.has("shape"):
		aoe = aoescenes[aoedata.shape].instantiate()
	else:
		aoe = aoescene.instantiate()
	add_child(aoe)
	
	#aoe.global_position = pos
	aoe.load_aoe(aoedata, pos, caster, origin)
	pass
	#aoe.activate()
	
func aoe_on_unit(aoedata, unit):
	aoe_at(aoedata, unit.global_position, unit)
		
func order_spellcast_at_target(spell, unit):
	var target
	if rules.hovered != null:
		if rules.hovered is Unit:
			unit.order_cast(spell, rules.hovered)
			
func order_spellcast_at_self(spell, unit):
	unit.order_cast(spell, unit)
	
func order_spellcast_at_mousepos(spell, unit):
	var pos = world.get_global_mouse_position()
	unit.order_square_cast(spell, pos)
	
func toggle_spell(spell, unit):
	spell.toggled = !spell.toggled
	unit.toggle_spell(spell, spell.toggled)

func insert_waypoint_at_mouse(pointkey, patrol, index):
	if data.waypoints.has(pointkey):
		var waypointdata = data.waypoints[pointkey]
		var waypoint = waypointscene.instantiate()
		waypoint.pos = {"x": highlighted.x, "y": highlighted.y}
		waypoint.map = self
		waypoint.id = rules.assign_id(waypoint)
		waypoint.patrol = patrol
		patrol.nodes.insert(index, waypoint)
		patrol.do_indexes()
		waypoint.position = blocks[highlighted.x][highlighted.y].position
		waypoints.merge({
			waypoint.id: waypoint
		})
		add_child(waypoint)

func make_waypoint_at_highlight(pointkey):
	make_waypoint_at_location(pointkey, highlighted.x, highlighted.y)

func make_waypoint_at_location(pointkey, x, y):
	if data.waypoints.has(pointkey):
		var waypointdata = data.waypoints[pointkey]
		var waypoint = waypointscene.instantiate()
		waypoint.pos = {"x": x, "y": y}
		waypoint.map = self
		waypoint.id = rules.assign_id(waypoint)
		waypoint.load_waypoint(waypointdata)
		var panel = rules.interface.selectpanel
		var route = panel.get_selected_route()
		if waypoint.type == "patrol":
			if route != null:
				route.add_node(waypoint)
		waypoint.position = blocks[highlighted.x][highlighted.y].position
		waypoints.merge({
			waypoint.id: waypoint
		})
		add_child(waypoint)
		return waypoint
	else:
		return null

func load_waypoint(savedata):
	make_waypoint_at_location(savedata.datakey, savedata.pos.x, savedata.pos.y)
	
func buff_aoe(buffkey):
	if data.buffs.has(buffkey):
		if rules.cursor_aoe != null:
			for key in rules.cursor_aoe.targets:
				var unit = rules.cursor_aoe.targets[key]
				var buff = data.buffs[buffkey]
				unit.apply_buff(buff)
	rules.stop_casting()
	
func drain_aoe(stat, amount):
	if rules.cursor_aoe != null:
		for key in rules.cursor_aoe.targets:
			var unit = rules.cursor_aoe.targets[key]
			unit.change_stat(stat, amount)
	rules.stop_casting()
				
func buff_hovered(buffkey):
	if data.buffs.has(buffkey):
		if rules.hovered != null:
			if rules.hovered.entity() == "UNIT":
				var buff = data.buffs[buffkey]
				rules.hovered.apply_buff(buff)
	pass

func make_evac_zone():
	var squares = []
	for i in range(1,blocks.size()-1,1):
		var square = blocks[i][1]
		squares.append(square)
	make_zone_from_squares("evac", squares)

func get_random_zonesquare(zonename):
	if zones.has(zonename):
		var rand = randi() % zones[zonename].size()
		var key = zones[zonename].keys()[rand]
		var zone = zones[zonename][key]
		var square = zone.get_random_square()
		return square
	return null


func make_zone_from_dragbox(zonename):
	var dragged = dragbox.stop_drag()
	make_zone_from_squares(zonename, dragged)
	
func make_zone_from_squares(zonename, squares):
	var zone = zonescene.instantiate()
	add_child(zone)
	zone.zonename = zonename
	zone.load_squares(squares)
	zone.id = rules.assign_id(zone)
	zones.merge({
		zonename: {}
	})
	zones[zonename].merge({
		zone.id: zone
	})
	

func get_squares(topleft, botright):
	var result = []
	var size = [botright[0]-topleft[0], botright[1]-topleft[1]]
	for i in size[0]:
		for j in size[1]:
			var x = i + topleft[0]
			var y = j + topleft[1]
			if x < blocks.size() && y < blocks.size():
				var square = blocks[x][y]
				result.append(square)
	return result

func drop_furniture():
	print("Placing")
	var furndata = data.furniture[preview.content.datakey]
	place_furniture(preview.angle, furndata, highlighted.x, highlighted.y, false, rules.debugvars.instabuild)
	if(!Input.is_action_pressed("queue_ghosts")):
		clear_preview()
		
func drop_tile():
	if tilepreview.tilebase != {}:
		place_tile(highlighted.x, highlighted.y, tilepreview.tilebase)
		
func flip_tile_at_cursor():
	if(current != null):
		if(current.containing):
			var footprint = current.get_print()
			var furn_id = footprint.get_furniture().id
			print(String.num(furn_id))
			if(furniture.has(furn_id)):
				remove_furniture(furn_id)
			NavigationServer2D.map_force_update(navmap)
		if(current.type() == "floor"):
			assign_fill(highlighted.x, highlighted.y)
		elif(current.type() == "wall"):
			assign_dig(highlighted.x, highlighted.y)
	
func place_item_at_cursor(itemname):
	if data.items.has(itemname):
		var item = data.items[itemname]
		spawn_item(item, highlighted.x, highlighted.y)
	
func place_unit_at_cursor(unitname):
	if data.wizards.unit.has(unitname):
		pass
	if data.units.has(unitname):
		var unit = data.units[unitname]
		if(current != null):
			var newunit = await spawn_unit(unit, current)
			
func order_cast_at_hovered(ability):
	if rules.hovered is Unit:
		ability.unit.order_cast(ability, rules.hovered)
			
func change_hovered_unit_stat(statname, amount):
	if rules.hovered is Unit:
		rules.hovered.change_stat(statname, amount)

#*****
#Spawner Functions
#*****

func find_square_within():
	var randx = randi_range(0, (x - 3))
	var randy = randi_range(0, (y - 3))
	return blocks[randx+1][randy+1]

func sort_units_by_role(newunits):
	var sorted = {}
	for id in newunits:
		var unit = newunits[id]
		for role in unit.roles:
			if sorted.has(role):
				sorted[role].merge({
					id: unit
				}, true)
			else:
				sorted.merge({
					role: {id: unit}
				})
	return sorted

func place_units_in_zone(zonename, units):
	var result = []
	if zones.has(zonename):
		var zone = zones[zonename].values()[0]
		for unit in units:
			var square = zone.get_random_square()
			if rules.factions.has(unit.allegiance):
				unit.set_faction(rules.factions[unit.allegiance])
			var newunit = await place_unit(unit, square.global_position)
			result.append(newunit)
	return result

func spawn_units_in_zone(zonename, units):
	var result = []
	if zones.has(zonename):
		var zone = zones[zonename].values()[0]
		for unit in units:
			var square = zone.get_random_square()
			var newunit = await spawn_unit(unit, square)
			result.append(newunit)
	return result

func spawn_unit_blob(units):
	var start = await find_square_within()
	for unit in units:
		var target = await start.get_movement(null)
		spawn_unit(unit, target)

func spawn_unit(unitdata, square):
	var squarepos = square.global_position
	var newunit = unitscene.instantiate()
	newunit.id = rules.assign_id(newunit)
	newunit.current_square = square
	newunit.global_position = square.cells.center.global_position
	newunit.map = self
	newunit.rules = rules
	newunit.data = data
	newunit.load_data(rules, data, unitdata)
	if newunit.master:
		if rules.player.master == null:
			rules.player.master = newunit
	if rules.factions.has(newunit.allegiance):
		newunit.set_faction(rules.factions[newunit.allegiance])
	newunit.process_mode = 1
	store_unit(newunit)
	world.add_unit(newunit)
	await unittree.insert(newunit)
	return newunit
	
func place_unit(unit, newposition):
	
	#unit.drop_task()
	store_unit(unit)
	unit.global_position = newposition
	units.merge({
		unit.id: unit
	})
	if unit.master:
		if rules.player.master == null:
			rules.player.master = unit
	await unittree.insert(unit)
	unit.halt()
	unit.spawned = false
	unit.map = self
	unit.process_mode = 1
	if encounter == null:
		unit.encounter = null
	world.add_unit(unit)
	await unittree.insert(unit)
	return unit
	
func remove_unit(unit):
	taskmaster.idle_units.erase(unit.id)
	for key in unit.in_sight_of:
		var seeing = unit.in_sight_of[key]
		seeing.unsee(unit)
	unittree.remove(unit)
	unit_leave(unit)
	units.erase(unit.id)
	world.remove_child(unit)
	#if encounter != null:
		#if encounter.team_goals.player == "killall":
			#check_encounter_completion()
	
func unit_leave(unit):
	taskmaster.idle_units.erase(unit.id)
	units.erase(unit.id)
	for key in unit.seen_by:
		var seeing = unit.seen_by[key]
		seeing.unsee(unit)
	#if encounter != null:
		#if encounter.goal == "killall":
			#check_encounter_completion()
	
func store_unit(unit):
	units.merge({
		unit.id: unit
	}, true)
	pass
	
func destroy_unit(unit):
	pass
	#if(units.has(unit.id)):
	#	units.erase(unit.id)
	
func disable_furniture(furniture):
	for tag in furniture.tags:
		if tag.type == "restoration":
			restores[tag.title].erase(furniture.id)
		if tag.type == "objective":
			objectives[tag.title].erase(furniture.id)
	
func find_spy_target(spy):
	var best
	var bestweight = 1000000000
	var bestheat = 0
	for heat in furniture_by_heat:
		#TODO: ACTUALLY SORT THIS FOR THE LOVE OF GOD
		if heat > bestheat:
			for key in furniture_by_heat[heat]:
				var newobj = furniture_by_heat[heat][key]
				if !spy.spied_on.has(newobj.id):
					var weight = spy.global_position.distance_squared_to(newobj.global_position)
					if weight < bestweight && !newobj.dead:
						best = newobj
						bestweight = weight
	return best
	
func find_objective(origin):
	var best
	var bestweight = 1000000000
	for key in objectives:
		for obkey in objectives[key]:
			var newobj = objectives[key][obkey]
			var weight = origin.distance_squared_to(newobj.global_position)
			if weight < bestweight && !newobj.dead:
				best = newobj
				bestweight = weight
	return best
	
func find_objective_tag(origin, tag):
	var best
	var bestweight = 1000000000
	if objectives.has(tag):
		for obkey in objectives[tag]:
			var newobj = objectives[tag][obkey]
			var weight = origin.distance_squared_to(newobj.global_position)
			if weight < bestweight && !newobj.dead:
				best = newobj
				bestweight = weight
	return best
	
func spawn_wave(squad):
	var entry = get_entry()
	squad.entry = entry.position
	
	squad.find_objective(self)
	squads.merge({squad.id: squad})
	var i = 0
	for key in squad.units:
		var unit = squad.units[key]
		if squad.sneaky:
			unit.enter_stealth()
		unit.aggressive = squad.aggressive
		unit.current_square = entry
		var unitspawn = entry.get_movement(null)
		unitspawn.reserved = true
		var spawnpoint = unitspawn.global_position + Vector2(randi() % 64, randi() % 64)
		place_unit(unit, spawnpoint)
		i += 64
	pass
	
func get_entry():
	if active_port != null:
		return active_port.get_square()
	if entry != null:
		return entry
	else:
		return find_edge()
		
func find_edge():
	var possible = []
	for i in x - 1:
		if blocks[i][1].type() == "floor":
			possible.append(blocks[i][1])
	for i in y - 1:
		if blocks[1][i].type() == "floor":
			possible.append(blocks[1][i])
	var rand = randi() % possible.size()
	return possible[rand]
	
func load_item(itemdata):
	if data.items.has(itemdata.base):
		var newitem = Stack.new(rules, data.items[itemdata.base], 3, self)
		newitem.rules = rules
		newitem.id = itemdata.id
		drop_object(newitem, itemdata.x, itemdata.y)
	
func spawn_item(base, x, y):
	var newitem = Stack.new(rules, base, 10, self)
	newitem.rules = rules
	newitem.id = rules.assign_id(newitem)
	drop_object(newitem, x, y)
	

	
func drop_object(item, x, y):
	var floorholder = itemscene.instantiate()
	var square = blocks[x][y]
	var pos = square.position
	floorholder.square = square
	floorholder.map = self
	floorholder.attach_item(item)
	floorholder.position = pos
	place_stack(item)
	print(stacks)
	floorstacks.append(floorholder)
	add_child(floorholder)
	
func place_stack(stack):
	stacks.merge({stack.base.id: []})
	stack.stack_empty.connect(remove_stack)
	stacks.get(stack.base.id).append(stack)
	
func add_job(job):
	if job.jobdata.type == "train":
		training_jobs.merge({
			job.jobname: []
		})
		training_jobs[job.jobname].append(job)
	if jobs.has(job.jobname):
		jobs[job.jobname].append(job)
	else:
		jobs.merge({
			job.jobname: [job]
		})
	
func remove_job(job):
	if jobs.has(job.jobname):
		jobs[job.jobname].erase(job)
	if jobs[job.jobname] == []:
		jobs.erase(job.jobname)
	
func remove_stack(stack):
	if stacks.has(stack.base.id):
		var has = stacks[stack.base.id].find(stack)
		if stack.location != null:
			if stack.location.entity() == "FLOORSTACK":
				var i = floorstacks.find(stack.location)
				if i != -1:
					floorstacks.pop_at(i)
				remove_child(stack.location)
		if has != -1:
			if stack.location is Furniture:
				pass
			stacks[stack.base.id].pop_at(has)#.call_deferred("free")
			pass
		else:
			pass
		if stacks.has(stack.base.id):
			if stacks[stack.base.id].size() == 0:
				stacks.erase(stack.base.id)
	pass
	
func add_patrol(new):
	patrols.append(new)
	new.map = self
	add_patrol_priority(new)
	
func add_patrol_priority(new):
	if patrols_by_priority.has(new.priority):
		patrols_by_priority[new.priority].append(new)
	else:
		patrols_by_priority.merge({
			new.priority: [new]
		})
		
func remove_patrol_priority(new):
	if patrols_by_priority.has(new.priority):
		var i = patrols_by_priority[new.priority].find(new)
		patrols_by_priority[new.priority].pop_at(i)
	
#finds a valid exit square for the given unit
func find_exit(unit):
	var zone = zones.evac.values()[0]
	var bestdist = 999999999999
	var best
	for key in zone.squares:
		var square = zone.squares[key]
		var dist = square.global_position.distance_squared_to(unit.global_position)
		if dist < bestdist:
			bestdist = dist
			best = square
	if best != null:
		return best
	return null
	
#*****
#Processing Functions
#*****

func unpaused_think(delta):
	
	if !taskmaster.assigning:
		await taskmaster.assign_hauls()
		await taskmaster.assign_closest_units()
		await taskmaster.assign_patrols()
		distribute_power()
		distribute_campower()
		units.erase(null)
		var done = []
		for key in stacks:
			var items = stacks[key]
			for item in items:
				item.storage_suitability()
		for key in active_jobs:
			var job = active_jobs[key]
			if job.time > 0:
				if job.can_do():
					await job.work(delta)
						
						#done.append(key)
			if job.time <= 0:
				if job.started:
					await job.complete()
				done.append(key)
		for key in done:
			active_jobs.erase(key)
		
		for key in units:
			var unit = units[key]
			if unit.is_node_ready():
				#await unit.think(delta)
				if unit.shelves.storage.contents != {}:
					pass
				if unit.quadtree != null:
					if await !unit.quadtree.contains(unit.global_position):
						await unittree.remove(unit)
						unit.quadtree = null
						if !await unittree.insert(unit):
							pass
					else:
						pass
				else:
					await unittree.remove(unit)
					if !await unittree.insert(unit):
						pass
				if unit.quadtree == null:
					pass
				if unit.spawned:
					await fight(unit, delta)
		
		for key in active_lessons:
			var lesson = active_lessons[key]
			if lesson.ready():
				if await lesson.learn(delta):
					await lesson.teach()
		for key in furniture:
			var furniture = furniture[key]
			await furniture.think(delta)
	if encounter != null:
		if !completed:
			check_encounter_completion()
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !get_tree().paused:
		unpaused_think(delta)
	

func _exit_tree():
	for child in get_children():
		child.queue_free()
	#NavigationServer2D.free_rid(navmap)

func unhighlight():
	#highlighted.x = -1
	#highlighted.y = -1
	#current = null
	pass

func highlight_square(x, y):
	highlighted.x = x
	highlighted.y = y
	current = blocks[x][y]
	cursor.position = blocks[x][y].position
	if rules.dragging != null:
		rules.dragging.position = current.position
		rules.dragging.pos = {"x": highlighted.x, "y": highlighted.y}
	place_preview()
	
func check_encounter_completion():
	if encounter.started:
		var playervic = true
		var enemyvic = true
		if encounter.team_goals.player == "killall":
			for key in units:
				var unit = units[key]
				if unit.allegiance == "player":
					enemyvic = false
				elif unit.allegiance == "coalition":
					playervic = false
		if playervic && !enemyvic:
			encounter_victory()
		elif !playervic && enemyvic:
			encounter_failure()
		elif playervic && enemyvic:
			encounter_draw()
	
func cleanup_map():
	completed = true
	
func encounter_victory():
	cleanup_map()
	await send_all_units_home()
	await encounter.complete_encounter(true)
	await rules.remove_map(id)
	
func encounter_failure():
	cleanup_map()
	await send_all_units_home()
	await encounter.complete_encounter(false)
	await rules.remove_map(id)
	
func encounter_draw():
	cleanup_map()
	await send_all_units_home()
	await rules.remove_map(id)
	
func send_all_units_home():
	if encounter != null:
		var transport = Transport.new(rules)
		transport.id = rules.assign_id(transport)
		rules.transports.merge({
			transport.id: transport
		})
		transport.needs_placement = false
		await transport.set_target(encounter.return_map)
		for key in units:
			var unit = units[key]
			if unit.faction == rules.factions.player:
				await transport.store_unit(unit)
			else:
				unit.faction.return_home(unit)
		transport.moving = true
	
#*****
#Furniture Functions
#*****
	
func add_teacher(teaches, furn):
	if teachers.has(teaches):
		teachers[teaches].merge({
			furn.id: furn
		})
	else:
		teachers.merge({
			teaches: {furn.id: furn}
		})
	
func valid_furniture(angle, spot, size, location):
	var is_valid
	var interactzone
	for n in size.x:
		for m in size.y:
			print("Testing: " + String.num(location.x + n) + "," + String.num(location.y - m))
			var testing = blocks[location.x + n][location.y - m]
			if testing.type() != "floor" || testing.containing:
				return false
	#if(angle == 0):
	#	interactzone = blocks[location.x + spot][location.y + size.y]
	#if(angle == 1):
	#	interactzone = blocks[location.x + size.y][location.y + spot]
	#if(angle == 2):
	#	interactzone = blocks[location.x - spot][location.y - size.y]
	#if(angle == 3):
	#	interactzone = blocks[location.x - size.y][location.y - spot]
	#if interactzone.type() != "floor" || interactzone.containing:
		#return false
	return true
			
func load_furniture(furndata, resuming):
	if data.furniture.has(furndata.datakey):
		var newdata = data.furniture[furndata.datakey]
		var furn = await place_furniture(furndata.angle, newdata, furndata.pos.x, furndata.pos.y, true, furndata.built)
		#if resuming:
		furn.load_save(furndata)
		return furn
			
func place_tile(x, y, tiledata, built = false):
	var square = blocks[x][y]
	if !built:
		square.make_build_job(tiledata)
	else:
		set_tile(x, y, tiledata)
		
func set_tile(x, y, tiledata):
	var square = blocks[x][y]
	square.set_content(tiledata)
	NavigationServer2D.map_force_update(navmap)
	
func place_furniture(angle, furndata, x, y, fromsave, built):
	if(valid_furniture(angle, 0, furndata.size, {"x": x, "y": y})):
		var newfurn = furniturescene.instantiate()
		newfurn.pos = {"x": x, "y": y}
		
		newfurn.print_tree_pretty()
		newfurn.map = self
		newfurn.rules = rules
		add_child(newfurn)
		newfurn.furniture_from_data(furndata, fromsave)
		
		
		
		if newfurn.door != null:
			for n in newfurn.size.x:
				for m in newfurn.size.y:
					blocks[x + n][y + m].add_door(newfurn.door)
		else:
			for n in newfurn.size.x:
				for m in newfurn.size.y:
					blocks[x + m][y + n].to_furniture(newfurn, newfurn.collision)
		if !(rules.debugvars.instabuild || built):
			newfurn.build(false)
		elif built:
			newfurn.build(true)
		
		var center = blocks[x][y].position
		center = Vector2(center.x + ((newfurn.size.x-1) * rules.squaresize)/2, center.y + ((newfurn.size.y-1) * rules.squaresize)/2)
		newfurn.position = center
		#newfurn.shape.global_position = center
		
		print(newfurn)
		
		
		newfurn.rotation_degrees = 90 * angle
		newfurn.angle = angle
		newfurn.set_process(true)
		
		newfurn.place_ghost()
		for tag in newfurn.tags:
			if(tag.type == "restoration"):
				if(!restores.has(tag.title)):
					restores.merge({tag.title: {}})
				restores.get(tag.title).merge({newfurn.id: newfurn}, true)
				print(restores)
			if(tag.type == "objective"):
				if(!objectives.has(tag.title)):
					objectives.merge({tag.title: {}})
				objectives.get(tag.title).merge({newfurn.id: newfurn})
				print(objectives)
			if tag.type == "accessory":
				if !accessories.has(tag.title):
					accessories.merge({
						tag.title: {}
					})
				accessories[tag.title].merge({
					newfurn.id: newfurn
				})
		if newfurn.type == "trainer":
			trainers.merge({
				newfurn.id: newfurn
			})
		if(newfurn.type == "container"):
			containers.merge({newfurn.id: newfurn})
		if newfurn.type == "depot":
			active_depot = newfurn
		if newfurn.type == "port":
			active_port = newfurn
		if newfurn.type == "lifepod":
			lifepods.merge({
				newfurn.id: newfurn
			})
		if newfurn.prison:
			prisons.merge({
				newfurn.id: newfurn
			})
		for teach in newfurn.teaches:
			add_teacher(teach, newfurn)
		
		if newfurn.camera != null:
			cameras.merge({
				newfurn.id: newfurn
			})	
		
		await furntree.insert(newfurn)
		furniture.merge({newfurn.id: newfurn})
		if furndata.spyheat != 0:
			furniture_by_heat.merge({
				furndata.spyheat: {}
			})
			furniture_by_heat[furndata.spyheat].merge({newfurn.id: newfurn})
		rules.ids.merge({
			newfurn.id: newfurn
		})
		return newfurn
	else:
		print("Spot Blocked")
			
func remove_furniture(furn_id):
	if(containers.has(furn_id)):
		containers.erase(furn_id)
	remove_child(furniture.get(furn_id))
	furniture.erase(furn_id)
	
func preview_tile(tiledata):
	tilepreview.load_tile(tiledata)
	tilepreview.active = true
	tilepreview.visible = true
	
func activate_preview(data):
	#if(preview != null):
		#remove_child(preview)
		#preview.queue_free()
	#preview = newpreview
	#add_child(preview)
	#preview.add_furniture(newpreview.content)
	preview.content.map = self
	preview.content.furniture_from_data(data, false, false)
	preview.active = true
	preview.visible = true
	
func clear_preview():
	
	preview.active = false
	rules.previewing = false
	preview.visible = false
	preview.position = Vector2(0, 0)
	
func place_preview():
	if(preview.active):
		if(current != null):
			var adjust = {"x": (preview.content.size.x - 1) * 32, "y": (preview.content.size.y - 1) * 32}
			preview.position = current.get_global_position() + Vector2(adjust.x, adjust.y)
			preview.update()
	if(tilepreview.active):
		if(current != null):
			#var adjust = {"x": (tilepreview.content.size.x - 1) * 32, "y": (tilepreview.content.size.y - 1) * 32}
			tilepreview.global_position = current.get_global_position()# + Vector2(adjust.x, adjust.y)
			pass
			#tilepreview.update()
	
func distribute_power():
	consumed_power = 0
	sort_priorities()
	for furn in furniture_by_priority:
		if consumed_power + furn.power_consumption <= power:
			consumed_power += furn.power_consumption
			furn.power(true)
		else:
			furn.power(false)
			
func distribute_campower():
	consumed_camerapower = 0
	for key in cameras:
		var furn = cameras[key]
		var camera = furn.camera
		if consumed_camerapower + camera.camerapower <= camerapower:
			consumed_camerapower += camera.camerapower
			camera.monitor(true)
		else:
			camera.monitor(false)
	
	
func sort_networks():
	pass
			
func sort_priorities():
	furniture_by_priority = []
	for key in furniture:
		var furn = furniture[key]
		if furn.built:
			furniture_by_priority.append(furn)
	
#*****
#Dig/Fill Functions
#*****
	
func assign_dig(x, y):
	var digdata = JobData.new({"action": "dig_wall", "args": [x, y], "speed": 5, "requirements": {}, "type": "digfill", "drains": {}, "rules": rules})
	#("dummy", ["health", 1], 1000000, {}, "interact", {"health": -3}, rules)
	var digjob = Job.new(digdata, self)
	digjob.doable = true
	digjob.map = self
	digjob.location = blocks[x][y]
	var digtask = Task.new("builder", blocks[x][y].global_position, digjob, "tilechanges", null)
	taskmaster.add_task(digtask)
	
func assign_fill(x, y):
	print(x)
	print(y)
	var filldata = JobData.new({"action": "fill_wall", "args": [x, y], "speed": 5, "requirements": {}, "type": "digfill",  "drains": {}, "rules": rules})
	var filljob = Job.new(filldata, self)
	filljob.doable = true
	filljob.map = self
	filljob.location = blocks[x][y]
	var filltask = Task.new("builder", blocks[x][y].global_position, filljob, "tilechanges", null)
	taskmaster.add_task(filltask)
	
func flip_cursor():
	flip_tile(highlighted.x, highlighted.y)
		
func flip_dragged():
	if !dragbox.dragging:
		await dragbox.start_drag()
	await dragbox.update_drag()
	var dragged = await dragbox.stop_drag()
	var oldtype = blocks[highlighted.x][highlighted.y].type()
	var newtype = ""
	if oldtype == "floor":
		newtype = "wall"
	elif oldtype == "wall":
		newtype = "floor"
	if dragged.size() != 1:
		for key in dragged:
			var square = dragged[key]
			flip_tile_to(newtype, square.x, square.y)
	else:
		flip_tile_to(newtype, highlighted.x, highlighted.y)
	
func flip_tile(x, y):
	var block = blocks[x][y]
	if !rules.debugvars.instabuild:
		var blocktype = block.type()
		if blocktype == "floor":
			assign_fill(x, y)
		elif blocktype == "wall":
			assign_dig(x, y)
		else:
			pass
	else:
		block.flip_tile()
		
func flip_tile_to(type, x, y):
	var block = blocks[x][y]
	var blocktype = block.type()
	if type != blocktype:
		flip_tile(x, y)
	
#*****
#Item Functions
#*****

func remove_floorstack(stack):
	var i = floorstacks.find(stack)
	if i != -1:
		floorstacks.pop_at(i)
	remove_child(stack)

func find_item_count_by_key(key):
	var result = 0
	if data.items.has(key):
		var base = data.items[key]
		result += find_item_count(base.id)
	return result
	
func find_item_count(base):
	var result = 0
	if stacks.has(base):
		var matching = stacks[base]
		for stack in matching:
			result += stack.count
	return result

func find_items(base):
	var results
	for item in stacks.get(base):
		results.append(item)

func find_item_amount(base, desire):
	pass
	
func find_item_amount_for(base, desire, requester = null):
	if desire > 0:
		#print(base)
		var closest = null
		var closestdistance = 1000000
		if stacks.has(base.id):
			var total = 0
			for item in stacks.get(base.id):
				total += item.count
			if total < desire:
				return null
			var found = false
			for item in stacks.get(base.id):
				if !(item.location is Unit):
					if item.shelf.name == "storage":
						if item.location != requester:
							var available = item.count - item.reserved_count
							if available >= desire:# && !item.needs_haul:
								var distance = distance_to_item(requester, item)
								if distance != -1:
									if distance < closestdistance:
										closest = item
										closestdistance = distance
			return closest
		else:
			return null
	else: return null
	
func find_container_for(stack, count):
	var closest = null
	var closestdistance = 9999999999999
	for key in containers:
		var container = containers[key]
		if container.shelves.storage.whitelist == [] || container.shelves.storage.whitelist.find(stack.base.key) != -1:
			var location = stack.location
			var distance = container.position.distance_squared_to(stack.location.position)
			if distance != -1:
				if distance < closestdistance:
					closest = container
					closestdistance = distance
	return closest
	
func find_teacher(lesson, student):
	var potential = {}
	if teachers.has(lesson):
		for key in teachers[lesson]:
			var options = teachers[lesson]
			for newid in options:
				var teacher = options[newid]
				if !teacher.in_use:
					potential.merge({
						teacher.id: teacher
					})
			var result = await furntree.closest(student.global_position, potential, false, "unit")
			return result
	
func find_accessory(tag, actor):
	if accessories.has(tag):
		var result = await furntree.closest(actor.global_position, accessories[tag], false, "unit")
		return result
		
#*****
#Distance Functions
#*****
func distance_to_item(loc, item):
	var path = NavigationServer2D.map_get_path(navmap, loc.global_position, item.location.global_position, true)
	var distance = 0.0
	for i in path.size() - 1:
		distance += path[i].distance_to(path[i+1])
	print(path)
	print(distance)
	return distance
	
func distance_to(loc1, loc2):
	var path = NavigationServer2D.map_get_path(navmap, loc1.global_position, loc2.global_position, true)
	var distance = 0.0
	for i in path.size() - 1:
		distance += path[i].distance_to(path[i+1])
	print(path)
	print(distance)
	return distance
	
func distance_between(loc1, loc2):
	var path = NavigationServer2D.map_get_path(navmap, loc1, loc2, true)
	var distance = 0.0
	for i in path.size() - 1:
		distance += path[i].distance_to(path[i+1])
	print(path)
	print(distance)
	return distance
	
func calc_h(ori, dest):
	var dx = abs(ori.x - dest.x)
	var dy = abs(ori.y - dest.y)
	var d = (dx + dy) + (1.41421356237 - 2) * min(dx, dy)
	return d
	#if dx > dy:
	#	return dx
	#else:
	#	return dy
	
func square_heap_push(heap, square, value):
	for i in heap:
		var curr = heap[i]
		
func square_weight(from, to):
	var direction = {"x": from.x - to.x, "y": from.y - to.y}
	var weight = from.weight + to.weight
	weight *= weight
	if direction.x != 0 && direction.y != 0:
		#Direction is diagonal
		weight *= 2
		pass
	else:
		#Direction is straight
		pass
	return weight
	
func a_star(origin: MovementArea, destination: MovementArea, unit, breaking = false):
	var tested = {}
	
	var from = {origin: null}
	
	#Cost from origin to neighbor
	var g = {origin: 0}
	#Cost from neighbor to goal
	var h = {origin: 0}
	
	#Total cost
	var f = {origin: 0}
	
	
	var found = false
	var queue: PriorityQueue = PriorityQueue.new()
	queue.insert(origin, 0)
	while !found:
		if !queue.empty():
			var current: MovementArea = queue.extract()
			if current.id == destination.id:
				found = true
				#from[destination] = {
				#	"cell": null,
				#	"link": null
				#}
				break
			var neighbors: Dictionary = current.neighbors()
			for dir in neighbors:
				var cell: MovementArea = neighbors[dir]
				var link: Link = current.links[dir]
				var square: Square = link.square
				var try_g: float = g[current] + link.weight
				var try_h: float = calc_h(cell, destination)
				var try_f: float = try_g + try_h
				var attempt = queue.priority_override_check(cell, try_g)
				if !tested.has(cell.id) && !attempt:
					var nav = link.square.can_navigate(unit)
					if nav == 0 || nav == 1 || (nav == 2 && breaking):
						if !f.has(cell) || f[cell] < try_f:
							g.merge({cell: try_g}, true)
							h.merge({cell: try_h}, true)
							f.merge({cell: try_f}, true)
							from.merge({cell: {"cell": current, "link": link}}, true)
							queue.insert(cell, try_g)
			tested.merge({
				current.id: current
			})
		else:
			return null
	var done = false
	
	if from.has(destination):
		var current = destination
		if from[destination] == null:
			return null
		var next = from[destination].cell
		var link = from[destination].link
		var path = []
		while !done:
			if next != null && next != origin:
				if current != origin:
					path.push_front({
						"cell": current,
						"link": link
						})
					current = next
					if from[current] != null:
						next = from[current].cell
						link = from[current].link
					else:
						next = null
			else:
				done = true
		return path
	else: return null
	
func get_trainers(unit):
	var result = {}
	for key in training_jobs:
		var newjobs = training_jobs[key]
		for job in newjobs:
			if job.can_perform(unit):
				result.merge({job.location.id: job})
	return result
	pass
	
func get_restores(need, unit):
	var result = {}
	if restores.has(need):
		for key in restores[need]:
			var restore = restores[need][key]
			if restore.can_use() && restore.primary_job.is_certified(unit, "interact"):
				result.merge({
					key: restore
				})
	return result
	
func get_prisons(unit):
	var result = {}
	for key in prisons:
		var prison = prisons[key]
		if prison.can_use():
			result.merge({
				key: prison
			})
	return result
	
func get_visible_squares(unit):
	pass
	
func get_squares_around(pos, squares, max_depth, depth = 0):
	pass
	
func get_direction(x, y, up, down, hollow = false):
	pass
	
func get_square_for_pos(vector):
	var x = int(vector.x)
	var y = int(vector.y)
	var xremain = x % rules.squaresize
	var yremain = y % rules.squaresize
	
	var xpos = (x - xremain) / rules.squaresize
	var ypos = (y - yremain) / rules.squaresize
	return blocks[xpos][ypos]
	
func load_view(view):
	for key in furniture:
		var furn = furniture[key]
		view.object_visibility(furn)
	for i in blocks.size():
		for j in blocks.size():
			var square = blocks[i][j]
			view.object_visibility(square)
	
func start_placement(units, mission):
	pass
	
func i_can_make_little_number_nines_appear():
	var pos = get_global_mouse_position()
	rules.make_floatnum(9, pos)
	
#*****
#Combat Functions
#*****

func fight(attacker, delta):
	attacker.fight(delta)
