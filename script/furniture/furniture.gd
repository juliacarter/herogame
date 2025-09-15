@tool
class_name Furniture
extends StaticBody2D


var id
var map: Grid
var object_name = "Doohickey"

var repeating = false
var waiting_for_resource = false
var countdown = 50

var quadtree

var object_priority = 0

var needs_build = true

var collision = true

var spawnframes = 3
var spawned = false

var waiting_for_repairs = false

var repairdrains = {"energy": 1}

@onready var data = get_node("/root/Data")

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

@onready var rules = get_node("/root/WorldVariables")
@onready var interact = get_node("InteractZone")
@onready var interactspot = get_node("InteractZone/InteractSpot")
@onready var select = get_node("SelectionBox")
@onready var sprite = get_node("Sprite2D")
@onready var indicator = get_node("StatusIndicator")

@onready var buildarea = get_node("BuildBox")
@onready var selectarea = get_node("SelectionBox")
@onready var buildbox = get_node("BuildBox/BuildBox")
@onready var selectbox = get_node("SelectionBox/SelectionBox")

@onready var highlight = get_node("Highlight")

@onready var shape = get_node("Shape")

var footprintspotterscene = load("res://footprint_spotter.tscn")
var conespotterscene = load("res://cone_spotter.tscn")

var camera
var trap

var buildshape
var selectshape

var spotscene = preload("res://scene/furniture/interact_zone.tscn")
var trapscene = preload("res://trap.tscn")

var tags = []

var jobs = []

var job_instances = {}

var patrol: Patrol

var sprite_texture
var sprite_path = "res://art/caution.png"
var model_path = "res://models/basic.tres"

var in_sight = {}
var seen = {}
var enemies = {}
var hostiles = {}
var seen_furniture = {}

var spyheat = 0

var allegiance

var spotters = {}

var size = {"x": 1, "y": 1}

var evasion = 0

var can_interact = {}
var can_build = {}

var build_ordered = false

var selectable = true
var built = true
var in_use = false
var dead = false
var powered = true

var power_consumption = 0

var durability = {
	"max": 30,
	"current": 30
}

#Grid index of the top left of the furniture
var pos = {"x": 0, "y": 0}

var spotlocs = {}
var spots = {}

var depot = false
var port = false

var transport: Transport
var door: Door

var angle = 0
var type

var pending = false

var task_queue = []
var assignments = []

var can_pop = true

var manual = true

var assigned_interactzone

var current_job
var primary_job
var job_options = {}

var job: Job
var jobdata = []

var buildjob: Job
var sabojob: Job
var spyjob: JobBase

var shelves = {}
var stored_items = {}
var pending_items = {}

var unitshelf = UnitShelf.new(self)
var unitcap = 0

var properties = {}

var teaches = {}

var datakey

var squares = []

var prison = false


func save():
	var saved_shelves = []
	var saved_jobs = []
	var saved_tasks = []
	var saved_assignments = []
	for i in task_queue.size():
		var task = task_queue[i]
		var assignment = assignments[i]
		saved_tasks.append(task.save())
		if assignment == null:
			saved_assignments.append(assignment)
		else:
			saved_assignments.append(assignment.id)
	for key in shelves:
		var shelf = shelves[key]
		saved_shelves.append(shelf.save())
	#for key in job_options:
		#var job = job_options[key]
		#saved_jobs.append(job.save())
	var save_dict = {
		"id": id,
		"jobs": saved_jobs,
		"shelves": saved_shelves,
		"datakey": datakey,
		"pos": pos,
		"angle": angle,
		"built": built,
		"durability": durability,
		"dead": dead,
	}
	if current_job != null:
		save_dict.merge({
			"current_job": current_job.id
		})
	return save_dict
	
func load_save(savedata, new = false):
	if data.furniture.has(savedata.datakey):
		furniture_from_data(data.furniture[savedata.datakey], false)
		#job_options = {}
		if !new:
			#for jobdata in savedata.jobs:
				#if data.jobs.has(jobdata.datakey):
					#var job = Job.new(data.jobs[jobdata.datakey], map)
					#job.id = jobdata.id
					#job.location = self
					#job.time = jobdata.time
					#job.taskmaster = map.taskmaster
					#job_options.merge({
					#	job.id: job
					#})
					#job.rules = rules
					#if primary_job == null:
					#	primary_job = job
					#job.id = rules.assign_id(job)
					#job.attach_furniture(self)
					#map.add_job(job)
			for tag in tags:
				if(tag.type == "restoration"):
					if(!map.restores.has(tag.title)):
						map.restores[tag.title].erase(id)
			#id = savedata.id
			for tag in tags:
				if(tag.type == "restoration"):
					if(!map.restores.has(tag.title)):
						map.restores[tag.title].erase(id)
					map.restores.merge({tag.title: {}})
					map.restores.get(tag.title).merge({id: self}, true)
			rules.assign_id(self)
			datakey = savedata.datakey
			pos = savedata.pos
			angle = savedata.angle
			build(savedata.built)
			durability = savedata.durability
			for shelfdata in savedata.shelves:
				var shelf = Shelf.new(shelfdata)
	return self
		
func load_ids(savedata):
	for jobid in savedata.job_options:
		if rules.ids.has(jobid):
			job_options.merge({
				jobid: rules.ids[jobid]
			})
	if savedata.has("current_job"):
		if rules.ids.has(savedata.current_job):
			current_job = rules.ids[savedata.current_job]

func _init():
	#set_process(false)
	pass
	
func power(val):
	if !powered && val:
		for key in job_options:
			var job = job_options[key]
			#await job.unpause()
	powered = val
	
func build(val):
	built = val
	if built:
		if door != null:
			door.close()
		
func construct():
	#buildarea.monitoring = false
	build(true)

func disable():
	set_process(false)
	selectable = false
	
func enable():
	set_process(true)
	selectable = true 
	
func load_furniture(newjob, newspots, newsize, newobject_name, spritename):
	pass
	
func queue_job(job):
	task_queue.push_back(job)
	
func pop_job_queue():
	var job = task_queue.pop_front()
	var unit
	return job
	
#check if this furniture can pop a Job, then do it
func check_job_queue():
	if current_job == null:
		if task_queue != []:
			var job = pop_job_queue()
			in_use = true
			current_job = job
			job.make_task()
	
func start_job(job, personal = false):
	
	var newjob = job.make_job()
	newjob.id = rules.assign_id(newjob)
	job_instances.merge({
		job.jobname: newjob
	})
	newjob.taskmaster = map.taskmaster
	newjob.rules = rules
	newjob.attach_furniture(self)
	#if job.automatic:
	var result = true
	if !personal:
		result = newjob.make_task()
	if primary_job == null:
		primary_job = newjob
	#map.add_job(newjob)
	if !result:
		return null
	#in_use = true
	newjob.start_job()
	return newjob
	
func finish_job(job):
	job_instances.erase(job.id)
	
func cancel_job(job):
	job_instances.erase(job.id)
	
	
func furniture_from_data(furndata, loaded, real = true):
	jobdata = furndata.jobdata
	datakey = furndata.datakey
	spyheat = furndata.spyheat
	prison = furndata.prison
	if real:
		if !loaded:
			for job in jobdata:
				var jobtype
				if rules.job_base_scripts.has(job.jobclass):
					jobtype = rules.job_base_scripts[job.jobclass]
				else:
					jobtype = rules.job_base_scripts.Job
				var newjob = jobtype.new(job, self)
				#newjob.id = rules.assign_id(newjob)
				job_options.merge({
					job.jobname: newjob
				})
				newjob.taskmaster = map.taskmaster
				newjob.rules = rules
				#newjob.attach_furniture(self)
				if primary_job == null:
					primary_job = newjob
				map.add_job(newjob)
		for teach in furndata.teaches:
			teaches.merge({
				teach: true
			})
		print(furndata.spots)
		spotlocs = {}
	resize(furndata.size.x, furndata.size.y)
	
	if real:
		if furndata.trapdata != {}:
			var newtrap = Trap.new()
			trap = newtrap
			if is_node_ready():	
				trap.rules = rules
		if furndata.camdata != {}:
			var newcam = SecurityCamera.new()
			camera = newcam
			camera.furniture = self
			if is_node_ready():
				camera.rules = rules
				
		if trap != null:
			trap.rules = rules
		if camera != null:
			camera.rules = rules
			camera.id = rules.assign_id(camera)
			#var newtrap = trapscene.instantiate()
			#newtrap.furniture = self
			#newtrap.load_trap(furndata.trapdata.spotters, furndata.trapdata.triggers)
			#add_child(newtrap)
			#trap = newtrap
			
		if furndata.spotters != []:
			load_spotters(furndata.spotters)
			
		for key in spotters:
			var spotter = spotters[key]
			spotter.area.area_entered.connect(_on_spotter_area_entered)
			spotter.area.area_exited.connect(_on_spotter_area_exited)
		
		manual = furndata.manual
		if !manual:
			for key in job_options:
				primary_job = job_options[key]
	
	for key in furndata.spots:
		for spot in furndata.spots[key]:
			var newspot = {}
			var newpos = spot.pos
			print(newpos)
			if spot.side % 2 == 1:
				if(newpos > size.y):
					newpos = size.y - 1
			else:
				if(newpos > size.x):
					newpos = size.x - 1
			newspot.merge({"pos": newpos})
			newspot.merge({"side": spot.get("side")})
			newspot.merge({"slot": key})
			print(newspot)
			spotlocs.merge({
				key: []
			})
			spotlocs[key].append(newspot)
	
	print(spotlocs)
	tags = furndata.tags
	
	if real:
		needs_build = furndata.needs_build
		build(!furndata.needs_build)
		
		depot = furndata.depot
		
		print(size)
		
		if primary_job != null:
			if primary_job.automatic:
				start_job(primary_job)
		
		for shelfdata in furndata.shelves:
			var shelf = Shelf.new(shelfdata)
			shelves.merge({
				shelf.name: shelf
			})
		#shelves = furndata.shelves
		for key in shelves:
			shelves[key].location = self
		
		type = furndata.type
		if type == "port":
			transport = Transport.new(rules)
		if type == "door":
			door = Door.new()
			door.furniture = self
			door.layers = [3]
	#if type == "patrol":
	#	if map.patrols.size() >= 1:
	#		patrol = map.patrols[0]
	#		patrol.nodes.append(self)
	#	else:
	#		map.patrols.append(Patrol.new())
	#		patrol = map.patrols[0]
	#		patrol.nodes.append(self)
	object_name = furndata.object_name
	sprite_path = "res://art/" + furndata.sprite_path + ".png"
	power_consumption = furndata.power
	model_path = furndata.model_path
	collision = furndata.collision
	print("loaded " + object_name + " from data")
	if is_node_ready():
		update_appearance()
		setspots()
	
func resize(x, y):
	print("resizing")
	size.x = x
	size.y = y
	if(buildbox != null && selectbox != null):
		var build = RectangleShape2D.new()
		build.size.x = size.x * rules.squaresize + 128
		build.size.y = size.y * rules.squaresize + 128
		buildbox.shape = build
		buildshape = build
		var select = RectangleShape2D.new()
		select.size.x = size.x * rules.squaresize
		select.size.y = size.y * rules.squaresize
		selectbox.shape = select
		selectshape = select
		var myshape = RectangleShape2D.new()
		myshape.size.x = size.x * rules.squaresize
		myshape.size.y = size.y * rules.squaresize
		shape = myshape
		pass
	
func is_real():
	return position



func make_job():
	await job.make_task()
	
func defend(attack, type, stat):
	var amount = attack.total_damage(type)
	#var armor = armor.get_defense(amount, 0, type, attack)
	if(damage(amount)):
		return die()

func damage(amount):
	if !dead:
		var value = 0
		for key in amount:
			value += amount[key]
		durability.current -= value
		if(durability.current <= 0):
			return true
		else:
			return false
	else:
		return false
		
func die():
	if rules.selected.has(id):
		rules.selected = null
		rules.interface.update_selection()
	map.destroy_unit(self)
	dead = true
	#waiting_for_repairs = true
	for key in job_instances:
		var job = job_instances[key]
		if job.task_exists:
			job.delete_task()
	map.disable_furniture(self)
	if(rules.selected != null):
		if(rules.selected.has(id)):
			rules.select(null)
	set_indicator()

func request_store(item, count):
	map.taskmaster.store_task(item, count)

func request_haul(base, count):
	await map.taskmaster.make_hauls(base, count, self, "storage", true, null)
	
func make_task_for_unit(unit):
	in_use = true
	var newjob = start_job(primary_job, true)
	var task = newjob.make_task_for_unit(unit)
	return task

func place_ghost():
	
	buildjob = Job.new(data.builddata, map)
	buildjob.taskmaster = map.taskmaster
	buildjob.location = self
	
	
	
	#buildjob.make_task()
	#built = false
	#if !built:
		#await buildjob.make_task()

func can_use(spottype = "interact"):
	var result = false
	var zones = spots[spottype]
	for zone in zones:
		if zone.actor == null:
			result = true
	return result

func update_appearance():
	var image = Image.load_from_file(sprite_path)
	sprite_texture = ImageTexture.create_from_image(image)
	if is_node_ready():
		sprite.texture = sprite_texture

func setspots():
	removespots()
	for key in spotlocs:
		for spot in spotlocs[key]:
			var newspot = spotscene.instantiate()
			var extra = 32
			spots.merge({spot.slot: []})
			spots[spot.slot].append(newspot)
			#spots.append(newspot)
			var updir = 0
			var sidedir = 0
			if spot.side == 0:
				newspot.position.x += (size.x * rules.squaresize) / 2.0 + extra
				newspot.relative_x = size.x
				newspot.relative_y = spot.pos
			if spot.side == 1:
				newspot.position.y += (size.y * rules.squaresize) / 2.0 + extra
				newspot.relative_x = spot.pos
				newspot.relative_y = size.y
			if spot.side == 2:
				newspot.position.x -= (size.x * rules.squaresize) / 2.0 + extra
				newspot.relative_x = -1
				newspot.relative_y = spot.pos
			if spot.side == 3:
				newspot.position.y -= (size.y * rules.squaresize) / 2.0 + extra
				newspot.relative_x = spot.pos
				newspot.relative_y = -1
			if(spot.side % 2 == 0):
				newspot.position.y -= size.x / 2.0 * rules.squaresize
				newspot.position.y += spot.pos * rules.squaresize + rules.squaresize / 2.0
			else:
				newspot.position.x -= size.y / 2.0 * rules.squaresize
				newspot.position.x += spot.pos * rules.squaresize + rules.squaresize / 2.0
			if angle == 0:
				newspot.square = map.blocks[pos.x + newspot.relative_x][pos.y + newspot.relative_y]
			if angle == 1:
				newspot.square = map.blocks[pos.x - newspot.relative_y][pos.y + newspot.relative_x]
			if angle == 2:
				newspot.square = map.blocks[pos.x - newspot.relative_x][pos.y - newspot.relative_y]
			if angle == 3:
				newspot.square = map.blocks[pos.x + newspot.relative_y][pos.y - newspot.relative_x]
			newspot.body_entered.connect(_on_interact_zone_body_entered)
			newspot.body_exited.connect(_on_interact_zone_body_exited)
			add_child(newspot)

func removespots():
	for key in spots:
		for spot in spots[key]:
			remove_child(spot)
	spots = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for key in spotters:
		var spotter = spotters[key]
		spotter.area.area_entered.connect(_on_spotter_area_entered)
		spotter.area.area_exited.connect(_on_spotter_area_exited)
	var image = Image.load_from_file(sprite_path)
	sprite_texture = ImageTexture.create_from_image(image)
	sprite.texture = sprite_texture
	
	
	buildarea.area_entered.connect(_on_build_box_area_entered)
	buildarea.area_exited.connect(_on_build_box_area_exited)
	
	print("Ready")
	
	indicator.visible = !built
	
	if id == null:
		id = WorldVariables.assign_id(self)
	setspots()
	print(size.x)
	print(size.y)
	
func pop_task():
	if(!task_queue.is_empty() && !assignments.is_empty()):
		can_pop = false
		var task = task_queue.pop_front()
		var assignment = assignments.pop_front()
		print(task)
		print(assignment)
		current_job = task.job
		if(assignment == null):
			map.taskmaster.add_task(task)
		else:
			assignment.queue.push_front(task)
			print(task_queue)
			print(task)
			print(assignments)
			print(assignment)
	if(task_queue.is_empty() && assignments.is_empty()):
		#current_job = null
		can_pop = true
	
func _physics_process(delta):
	pass
	
func spawn():
	sabojob = Job.new(data.sabodata, map)
	sabojob.taskmaster = map.taskmaster
	sabojob.id = rules.assign_id(sabojob)
	sabojob.location = self
	
	spyjob = JobBase.new(data.spydata, self)
	spyjob.taskmaster = map.taskmaster
	spyjob.rules = rules
	spawned = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func think(delta):
	if(!spawned):
		if spawnframes == 0:
			spawn()
		else:
			spawnframes = spawnframes - 1
	else:
		set_indicator()
		if(built):
			if !dead:
				check_job_queue()
				if current_job != null:
					if current_job.waiting_for_resource:
						if !current_job.task_exists:
							#current_job.try_make()
							pass
				if current_job == null:
					pass
				if shelves.has("theft"):
					if shelves.theft.contents != {}:
						for key in shelves.theft.contents:
							var item = shelves.theft.contents[key]
							shelves.theft.remove(item.base.id, item.count)
				
				if powered:
					if primary_job != null:
						if primary_job.service:
							if !primary_job.can_serve():
								primary_job.request_serve()
					if(job_options != {}):
						for key in job_options:
							var job = job_options[key]
							#if job.automatic:
								#pass
								#if !job.task_exists && !job.waiting_for_resource:
									#job.make_task()
								#elif job.waiting_for_resource:
									#if job.check_needs().is_empty():
										#job.make_task()
								#if job.task_exists && job.automatic:
									#if job.work(delta):
										#job.complete()
							#else:
								#if job.waiting_for_resource:
									#job.check_ready()
						if(can_pop && task_queue != []):
							print("JOBALERT: popping from job")
							await pop_task()
						#elif primary_job != null:
							#if primary_job.automatic && primary_job.task_exists:
								#if primary_job.work(delta):
									#primary_job.complete()
				elif !powered:
					pause()
			else:
				if !waiting_for_repairs:
					order_repair()
		else:
			if(buildjob != null):
				if(buildjob.queued):
					pop_task()
				elif !buildjob.task_exists && !buildjob.waiting_for_resource:
					buildjob.make_task()

func number_popup(value, color = "damage"):
	var randx = randf_range(-16, 16)
	var randy = randf_range(-32, 0)
	var pos = global_position + Vector2(randx, randy)
	rules.make_floatnum(value, pos, color)

func pause():
	if current_job != null:
		current_job.pause()

func entity():
	return "FURNITURE"

func order_repair():
	var task = RepairTask.new(self)
	waiting_for_repairs = true
	map.taskmaster.add_task(task)
	
##########Container Functions

func store_unit_for_transport(unit):
	if unitshelf.store_unit(unit):
		if unitshelf.check_units():
			transport_units(unitshelf.units, transport.targetmap)
			
func store_unit(unit):
	if unitshelf.store_unit(unit):
		unit.global_position = global_position
			
func transport_units(units, map):
	for key in units:
		var unit = units[key]
		rules.transfer_unit(unit, map)

func request(base, count, shelf = "storage"):
	var item = await map.taskmaster.make_hauls(base, count, self, shelf, false, null)
	pass

func depot_order(base, count, free = false):
	var newitem = await create(base, count, "output", false)
	if !free:
		var cost = base.price * count
		rules.player.cash -= cost
	#map.taskmaster.targeted_haul(newitem, count, location, shelf, final)

func depot_fill(base, count):
	var newitem = await create(base.key, count, "output", false)
	var cost = base.price * count
	rules.player.cash -= cost
	
func depot_sell(base, count):
	var sold = shelves.sell.split(base.id, count)
	map.remove_stack(sold)
	rules.player.intangibles.cash += count * base.price
	return sold.count
	
func sell_storage():
	for base in shelves.storage.contents:
		depot_sell(base, shelves.storage.contents[base.id].count)
	
func fill_up():
	for name in data.items:
		var base = data.items[name]
		map.taskmaster.haul_task(base, 1, self, "storage", true, null)
		pass
	
func take_from(base, count, shelf = "storage"):
	if shelves.has(shelf):
		return shelves[shelf].split(base, count)
	else:
		return shelves.output.split(base, count)
		
func remove_item(base, count, shelf = "storage"):
	if shelves.has(shelf):
		return shelves[shelf].remove(base, count)
	else:
		return shelves.output.remove(base, count)
	
func create(basename, count, shelf = "output", needs_store = false):
	if data.items.has(basename):
		var base = data.items[basename]
		var newstack = Stack.new(rules, base, count, map)
		newstack.rules = rules
		newstack.location = self
		
		if newstack.id == null:
			newstack.id = rules.assign_id(newstack)
			
		map.place_stack(newstack)
		
		#if needs_store:
			#newstack.reserved = true
			#newstack.reserved_count = count
		
		await store(newstack, shelf, !needs_store)
		
		
		
		#if needs_store:
			#newstack.needs_haul = true
			#map.taskmaster.needs_haul.merge({
			#	newstack.id: newstack
			#})
		
		return newstack
	
	
func store(item, shelf, final):
	item.location = self
	#if !final:
		#item.reserved = true
	if final:
		item.reserved = false
		item.reserved_count = 0
	await shelves[shelf].store(item)
		
	pass
			
func remove(base, shelf, count):
	shelves[shelf].remove(base, count)
	
func allitems():
	var result = []
	for key in shelves:
		var shelf = shelves[key]
		for base in shelves[key].contents:
			result.append({"base": base, "count": shelf.contents[base].count})
	return result
	
func count(base):
	var count = 0
	for key in shelves:
		var shelf = shelves[key]
		if shelf.contents.has(base):
			for item in shelf.contents.get(base):
				count += 1
	return count

func contains(base):
	for key in shelves:
		var shelf = shelves[key]
		if shelf.contents.has(base):
			return shelf.contents[base]
	return null
	
func reserved_by(base, reserve):
	var result = []
	for key in shelves:
		var shelf = shelves[key]
		if shelf.contents.has(base):
			for item in shelf.contents.get(base):
				if(item.reserved == reserve):
					result.append(item)
	return result
	
func remove_items(base, amount):
	var count
	for key in shelves:
		var shelf = shelves[key]
		if shelf.contents.has(base):
			var items = shelf.contents.get(base)
			for i in items.size():
				if(count == amount):
					return true
				else:
					count += 1
			
func remove_reserved_items(base, amount, reserved):
	pass

func set_indicator():
	if !dead && powered && built:
		indicator.visible = false
	elif dead:
		indicator.visible = true
		indicator.set_sprite("dead")
	elif !built:
		indicator.visible = true
		indicator.set_sprite("build")
	elif !powered:
		indicator.visible = true
		indicator.set_sprite("power")

func _on_selection_box_mouse_entered():
	await rules.hover(self) # Replace with function body.


func _on_selection_box_mouse_exited():
	if rules.hovered != null:
		if rules.hovered.id == id:
			await rules.hover(null)


func _on_interact_zone_body_entered(area):
	can_interact.merge({area.id: area}, true)
	#print(can_interact)


func _on_interact_zone_body_exited(area):
	if area.current_task != null:
		if area.current_task.type == "store":
			pass
	if(can_interact.has(area.id)):
		can_interact.erase(area.id)
	#print(can_interact)


func _on_build_box_area_entered(area):
	can_build.merge({area.id: area})


func _on_build_box_area_exited(area):
	if(can_build.has(area.id)):
		can_build.erase(area.id)

func get_square(origin = null, reserving = false, spotname = "interact"):
	var potential = []
	if spotname != "" && spots.has(spotname) && spots[spotname].size() > 0:
			for spot in spots[spotname]:
				if (!spot.in_use || !reserving):
					potential.append(spot)
	else:
		pass
		for i in size.x + 2:
			var xval = pos.x + (i - 1)
			var yval = pos.y + size.y
			potential.append({"square": map.blocks[xval][pos.y-1]})
			potential.append({"square": map.blocks[xval][yval]})
		for i in size.y + 2:
			var xval = pos.x + size.x
			var yval = pos.y + (i - 1)
			potential.append({"square": map.blocks[pos.x-1][yval]})
			potential.append({"square": map.blocks[xval][yval]})
	if origin == null:
		if potential != []:
			var result = potential[0]
			if reserving:
				if result is InteractZone:
					result.in_use = true
			if result.square.footprint != null:
				pass
			return result.square
		else:
			return map.blocks[pos.x][pos.y]
	var best = null
	var bestweight = 9999999
	if origin != null:
		for spot in potential:
			var square = spot.square
			var weight = square.position.distance_squared_to(origin.global_position)
			if weight < bestweight:
				best = spot
				bestweight = weight
	else:
		best = potential[0]
	if best == null:
		return null
	if best.square.footprint != null:
		pass
	if reserving:
		if best is InteractZone:
			best.actor = origin
			best.in_use = true
			origin.current_interactzone = best
	return best.square
	
func get_interact(slot = "interact"):
	var result = []
	for spot in spots:
		if !spot.in_use:
			result.append(spot)
	
func fix():
	dead = false
	waiting_for_repairs = false
	
func repair(delta, worker = null):
	if(worker != null):
		worker.apply_drain(repairdrains, delta)
	in_use = true
	var newvalue = durability.current + worker.get_repair_value(self, delta)
	if newvalue >= durability.max:
		durability.current = durability.max
	else:
		durability.current = newvalue
	if(durability.current == durability.max):
		fix()
		return true
	else:
		return false
		

func enter_sight(body):
	if body.entity() == "UNIT":
		in_sight.merge({
			body.id: body
		}, true)
		body.in_sight_of.merge({
			id: self
		})
		if !body.stealthed:
			see(body)
		else:
			if body.allegiance != allegiance:
				body.hide_from(self)
	elif body.entity() == "FURNITURE":
		seen_furniture.merge({
			body.id: body
		}, true)
		
func see(body):
	if body.entity() == "UNIT":
		seen.merge({body.id: body})
		if body.allegiance != allegiance:
			if body.aggressive:
				hostiles.merge({body.id: body})
			else:
				enemies.merge({body.id: body})
		body.seen_by.merge({id: self})
	
func clear_sight():
	for key in in_sight:
		var object = in_sight[key]
		leave_sight(object)
	
func leave_sight(body):
	if body.entity() == "UNIT":
		in_sight.erase(body.id)
	elif body.entity() == "FURNITURE":
		seen_furniture.erase(body.id)
	unsee(body)
	
func unsee(body):
	if body.entity() == "UNIT":
		in_sight.erase(body.id)
		body.in_sight_of.erase(id)
		if(seen.has(body.id)):
			seen.erase(body.id)
		if(enemies.has(body.id)):
			enemies.erase(body.id)
		if(hostiles.has(body.id)):
			hostiles.erase(body.id)
		if(body.seen_by.has(id)):
			body.seen_by.erase(id)
	elif body.entity() == "FURNITURE":
		seen_furniture.erase(body.id)
		
func load_spotters(newspotters):
	for spotterdata in newspotters:
		var spotter
		if spotterdata.type == "cone":
			spotter = conespotterscene.instantiate()
		else:
			spotter = footprintspotterscene.instantiate()
			spotters.merge({
				spotterdata.type: spotter
			})
			spotter.set_spotter({}, self)
			add_child(spotter)
			
			
func _on_spotter_area_entered(area):
	if trap != null:
		trap.enter_trap(area)
	if camera != null:
		if camera.monitoring:
			enter_sight(area)
	
func _on_spotter_area_exited(area):
	if trap != null:
		trap.exit_trap(area)
	if camera != null:
		leave_sight(area)
		
func unreserve_slots(slot = null):
	if slot == null:
		for key in spots:
			for spot in spots[key]:
				spot.actor = null
				spot.in_use = false
	else:
		if spots.has(slot):
			for spot in spots[slot]:
				spot.actor = null
				spot.in_use = false
		
func get_spot_actors(spotname):
	var result = []
	if spots.has(spotname):
		for spot in spots[spotname]:
			if spot.actor != null:
				result.append(spot.actor)
	return result
		
func spots_filled(spotname, spotdata):
	if spots.has(spotname):
		for spot in spots[spotname]:
			pass
			
func make_exfil():
	var job = start_job(primary_job, true)
	return job
		
