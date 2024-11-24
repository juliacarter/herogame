@tool
class_name Unit
extends RigidBody2D

signal unit_spawned(unit)
signal unit_died(unit)

signal buff_added(buff)
signal buff_removed(buff)
signal buff_update(buff)

signal action_used(action, target)

signal attack_hit(attack, target)
signal attack_miss(attack, target)

signal hit_by(victim, attacker, attack)

signal task_started(task, unit)
signal task_complete(task, unit)

var targetable = false

var tooltip
var tooltip_active = false

var thread: Thread

var faction

var moving = true

@onready var pushcast = get_node("PushCast")

#Heroic units don't die, are instead put into "comatose" state when defeated
#comatose heroes need to be healed with advanced medical technology, or spend time at a Hospital node
#or Captured if defeated in an encounter
var heroic = true

var movement_speed: float = 200

#flip this true after a unit has been pushed
#being pushed prevents a unit from doing anything besides moving towards a destination
#basically, prevent anything that would require a halt
var forced_movement = false

var speeds = {
	"run": 200,
	"walk": 100,
}

var current_speed = "run"

var status_buildup = {
	
}

var overtime = {}

var movement_target_position: Vector2 = Vector2(50, 50)
var movement_delta: float

@onready var animplayer = get_node("AnimationPlayer")
@onready var nav = get_node("NavigationAgent2D")
@onready var body = get_node("RigidBody2D")

@onready var sprites = get_node("Appearance/Sprites")

@onready var appearanceholder = get_node("Appearance")

@onready var hearing = get_node("HearingRadius")

var defecting = false

var alerted = false

var navigation_finished = true

var movement_path
var current_square
var current_cell
var target_cell

var object_priority = 0

var repathtimer = 1
var repathsetting = 1

var scaling = 0.0
var level = 0

var chat_timer = 5.0

#unit's role in its current encounter
var encounter_role = ""

#The time between the unit's loyalty tests
#Loyalty tests only happen when loyalty is low
var loyalty_timer = 5.0

var slack_timer = 30.0


var casting_timer = 0.0

var casting_

var slacking = false

var used_auglimits = {
	"unlimited": 0,
	"science": 0,
	"lesson": 0
}
var auglimits = {
	#Not really unlimited, but it ought to be good enough
	"unlimited": 9223372036854775807,
	"science": 0,
	"lesson": 4,
	"trait": 9999999
}


var cultivation = {
	"unlimited": 0,
	"science": 0,
	"lesson": 4,
	"trait": 999999999
}

var experience = 0.0
var needed_experience = 1000.0

#Experience gained from defeating this unit
var experience_reward = 100.0

var master = false

#The unit's opinion of each other unit
var unit_opinions = {}

var woundpoints = 0
var woundpoints_needed = 100


#List of jobs the minion wants to be escorted to. Used to prevent jobs trying to escort units that are gone.
#Typically minions will only be able to be targeted by one type of escort job
#Rescue for friendlies, Capture for enemies
var escorted = {
	
}
var captured = false
var rescued = false

var triggers = {
	
}

var base_upkeep = {}
var upkeep_mods = {}

var upkeep = {}

#Units can't get Interest or Heat from the same object twice, so put them here so they can be ignored for objective finding and spotting
var heat = 0
var interest = 0

var already_spotted = {}
var spied_on = {}

@onready var stealthind = get_node("StealthIndic")

@onready var bodysprites = get_node("Appearance/Sprites/Body")
@onready var headsprites = get_node("Appearance/Sprites/Head")
@onready var weaponsprites = get_node("Appearance/Sprites/Weapon")

var job_instances = {}

var vision_radius = 500

@onready var rules = get_node("/root/WorldVariables")
@onready var data = get_node("/root/Data")
@onready var item = get_node("Item")

@onready var highlight = get_node("Highlight")

var radscene = load("res://attack_radius.tscn")

var beamscene = load("res://attack_beam.tscn")
var beam

var squads = {}

var aurascene = load("res://aura.tscn")

var new = true


var clearances = {}
var orders = []

var passive_drains = {}
var starvation_drains = {
	"health": 0.2,
	"loyalty": 2.0
}

@onready var rays = [
	get_node("UpRay"),
	get_node("URRay"),
	get_node("RightRay"),
	get_node("DRRay"),
	get_node("DownRay"),
	get_node("DLRay"),
	get_node("LeftRay"),
	get_node("ULRay"),
]

var stealthed = false
var disguise: Disguise

var unitshelf: UnitShelf = UnitShelf.new(self)

@onready var prog = get_node("Progress")
@onready var healthbar = get_node("Health")
@onready var energybar = get_node("Energy")

@onready var vision = get_node("Vision")
@onready var visioncone = get_node("VisionCone2D")

@onready var unitsprite = get_node("Appearance/Sprites/Body/BodySprite")
@onready var skintoner = get_node("Appearance/Sprites/Head/SkinToner")
@onready var chesttoner = get_node("Appearance/Sprites/Body/ChestToner")
#@onready var legtoner = get_node("Sprites/Body/LegToner")

var clothingsprites = {}

@onready var tspotter = get_node("TerrainSpotter")


@export var firstname = "Joe"
@export var lastname = ""
@export var nickname = "Bubba"
var needs_name = true

var skintone: Color
var id: String

#roles used for on-map jobs
var roles = ["minion"]
#roles used "off-map"
var meta_roles = ["soldier"]

var can_interact = {}

var current_interactzone: InteractZone

@export var allegiance = "neutral"

@export var sight = 4
@export var health = 10
@export var energy = 10
@export var loyalty = 10

var aggression_active = true

var aggtype = "defensive"

@export var aggressive = false
var warcriminal = true
@export var appearance = "minion"

var unit_class: UnitClass
var unit_origin

var quadtree

var stored_in = null

var evasion = 0
var baseaccuracy = 75

var squad: Squad
var encounter: Encounter

var fleetimer = 0.0
var scantimer = 0.0
var wandertimer = 0.0

var talktimer = 0.0

var breakingandentering = false

var seen = {}

var heard = {}

var relations ={}

var in_sight = {}

var can_hear = {}

var enemies = {}
var hostiles = {}

#Enemies/hostiles that pose no combat threat will be moved here
var neutralized = {}

var melee_attacking = false
var in_melee = false
var melee_range = {}

var seen_by = {}
var in_sight_of = {}

var targeted_by = {}

var seen_furniture = {}

var buffs = []

var shelves = {
"storage": Shelf.new({
	"name": "storage"
}),
"input": Shelf.new({
	"name": "input"
}),

}

var equipment = {
	"armor": null,
	"weapon": null,
	"head": null
}
var equip_overrides = {
	"armor": null,
	"weapon": null,
	"head": null,
}
var wants_equipment = {
	"armor": false,
	"weapon": false,
	"head": false
}
var slot_limits = {
	"armor": 1,
	"weapon": 2,
	"head": 1,
}

#amount of items currently in slots
var slot_amount = {
	"armor": 0,
	"weapon": 0,
	"head": 0,
}

var equipped = []

var selectable = true

var free_weight = 2
var future_weight = 0

#Add the names of the queues the unit looks at here, listed in descending order of priorities
var priorities = []

var statpriorities =["health", "energy", "food", "loyalty"]

var weapon: Attack

var fists: Attack

var actions = {}

var action_priority = ActionPriority.new()

var queued_actions = []

#spells toggled on
var toggled_spells = {
	
}

var cast_time = 0.0
var casting_action
var casting_target

var attacks = {
	
}
var attack_slots = {
	"unarmed": "fist",
	"main": "",
	"secondary": "",
}

var attack_priority = []

var attackshapes = {
	
}

var prot: Protection

var defense = Defense.new()

var status_resist = {
	"burn": 25
}

var tools = []

var map

#whether the Unit is on a physical map or not
#units not on a Map behave differently
#have simplifies logic & transport rules
var on_map = false

var spawned = false
var spawnframes = 3

var arrived = false

var working = false
var combat = false
var fighting = false
var idle = false
var rallied = false
var active = false
var rnr = false
var tired = false


var capturable = false
var imprisoned = false
var asleep = false

var fixrate = 3.0

var storing = false

var stored = false
var transporting = false

var holding = false

var current_task: Task
var queue = []
var movement = []

var flee_target

var movement_square

var target_furniture
var current_target
var next_target

#hints this unit uses while in combat
var hints = {}

#hints given to units that target this unit
var target_hints = {}

var preferred_range = 512 * 512
var attack_range = 512 * 512

var dead = false
var decay = 1

var shield = 0

var weapondata = {}

var verbose = false

var potential = {
	"combat": 1.0,
	"work": 1.0
}

var statexp = {
	
}

var statexp_needed = {
	
}

#units will seek rest when the stat's damage is above this level
#units always seet rest when stat damage is full
var damage_thresholds = {
	"attention": 10
}
#units go rest when idle and stat damage is above this level. ignore if higher than normal damage threshold
var soft_damage_thresholds = {
	"attention": 1
}
#go rest when value is below this level
var value_thresholds = {
	"health": 100
}
#go rest when value is below this level & unit is idle
var soft_value_thresholds = {
	"health": 199
}

var stats = {
	"fuels": {},
	"qualities": {},
	"skills": {},
}
var all_stats = {}

var ratings = {}

var needs = {}


var filling = {}

var lessonmax = 1


var learning = {}
var known = []

var augmenting = {}
var augmented = []

var upgrading = {
	"unlimited": {},
	"lesson": {},
	"augment": {},
	"traits": {},
}
var upgrades = []

var points = {
	
}

var lesson_picks = 0

#Lessons that are not associated with the unit's Class
var extra_lessons = {}

var abilities = {}
var active_abilities = {}

#{ability: aura}
var auras = {
	
}

var effects = {}

var modifiers = {}
var mods = Modifiers.new()



var datakey



func increase_rating(ratingname, amount):
	if ratings.has(ratingname):
		ratings[ratingname].increase_rating(amount)
	else:
		var rating = Rating.new({})
		rating.key = ratingname
		rating.value = amount
		ratings.merge({
			ratingname: rating
		})
		
func decrease_rating(ratingname, amount):
	if ratings.has(ratingname):
		ratings[ratingname].decrease_rating(amount)
		if ratings[ratingname].value <= 0:
			ratings.erase(ratingname)

func get_accessible_furniture(potential = {}):
	var tiles = get_accessible_tiles()
	var result = {}
	for key in tiles:
		var square = tiles[key]
		if square.footprint != null:
			var furn = square.footprint.content
			if furn != null:
				if !result.has(furn.id):
					if potential == {} || potential.has(furn.id):
						result.merge({
							furn.id: furn.content
						})
	return result

func get_accessible_tiles():
	var open = {}
	var closed = {}
	var possible = {}
	open.merge({
		current_square.id: current_square
	})
	while open.size() > 0:
		var key: String = open.keys()[0]
		var square = open[key]
		open.erase(key)
		var nav = square.can_navigate(self)
		closed.merge({
			square.id: square
		})
		if nav == 1 || nav == 0:
			possible.merge({
				square.id: square
			})
			
			var neighbors = square.neighbors()
			for neighbor in neighbors:
				if !closed.has(neighbor.id) && !open.has(neighbor.id):
					open.merge({
						neighbor.id: neighbor
					})
	return possible

func find_conversation_target():
	var possible = []
	for key in can_hear:
		var unit = can_hear[key]
		if unit.current_task == null || unit.current_task.type == "idle":
			possible.append(unit)
	var rand = randi() % possible.size()
	var target = possible[rand]
	try_talking_to(target)

func try_talking_to(target):
	#For now, just have them walk to you. This behavior should vary based on type of convo
	var convo = Conversation.new(global_position)
	var talktask = TalkTask.new(convo)
	
func order_square_cast(ability, target):
	var task = GroundCastTask.new(ability, target)
	drop_task()
	update_task(task)

func order_position_cast(ability, target):
	pass

func order_cast(ability, target):
	var task = CastTask.new(ability, target)
	drop_task()
	update_task(task)

func toggle_spell(spell, status):
	if status:
		toggle_spell_on(spell)
	else:
		toggle_spell_off(spell)
	

func toggle_spell_on(spell):
	spell.toggle(true)
	if !toggled_spells.has(spell):
		toggled_spells.merge({
				spell: true
			})
		for ability in spell.applied_abilities:
			var count = spell.applied_abilities[ability]
			add_ability_by_name(ability, count)
	
func toggle_spell_off(spell):
	spell.toggle(false)
	if toggled_spells.has(spell):
		toggled_spells.erase(spell)
		for ability in spell.applied_abilities:
			var count = spell.applied_abilities[ability]
			remove_ability_by_name(ability, count)

#TRUE = aggression has just been toggled on
func target_aggression(unit):
	neutralized.erase(unit.id)
	enemies.erase(unit.id)
	hostiles.erase(unit.id)
	be_untargeted(unit)
	if current_target != null && current_target.id != unit.id:
		change_target(null)
		scan_for_hostile()
	add_enemy(unit)
	
func toggle_self_aggression(newval):
	if !newval:
		stop_combat()
	aggression_active = newval
	change_target(null)
	target_furniture = null
	for key in in_sight_of:
		var sighted = in_sight_of[key]
		sighted.target_aggression(self)

func trigger(trigger_name, triggered_by):
	if triggers.has(trigger_name):
		for triggerdata in triggers[trigger_name]:
			if triggerdata.check_conditions(self, triggered_by):
				var action = triggerdata.action
				var args = triggerdata.get_args(self, triggered_by)
				rules.callv(action, args)

func start_personal_job(jobname, with_resources = false, object = null):
	var jobdata = data.jobs[jobname]
	var job = Job.new(jobdata, map)
	job.taskmaster = map.taskmaster
	job.id = rules.assign_id(job)
	if object == null:
		job.attach_furniture(self)
	else:
		job.attach_furniture(object)
	
	#job.desiredactors.interact.actors.append(self)
	
	if job.desiredspot != "" && object == null:
		var furn = await map.find_accessory(job.desiredspot, self)
		job.location = furn.object
	if with_resources:
		for key in job.neededitems:
			job.location.create(key.key, job.neededitems[key], "input")
	job.assign_actor(self, "interact")
	job_instances.merge({
		job.id: job
	})
	pass
	
func create(base, count, shelf = "storage", needs_store = false):
	var item = Stack.new(rules, base, count, map)
	if item.id == null:
		item.id = rules.assign_id(item)
	shelves.storage.store(item)
	
	
func end_personal_job(job):
	if job != null:
		job_instances.erase(job.id)

func _enter_tree():
	#load_sprite()
	pass
	
func _exit_tree():
	seen = {}

func generate_name():
	firstname = await data.firstnames.pick_random()
	lastname = await data.lastnames.pick_random()
	nickname = await data.nicknames.pick_random()

func generate_skintone():
	var skintone = await data.skintones.pick_random()
	skintoner.modulate = skintone

func make_attack_radius(newattack, slot):
	var radius = radscene.instantiate()
	radius.unit = self
	attackshapes.merge({
		newattack.key: radius
	}, true)
	add_child(radius)
	radius.set_size(newattack.range)
	pass

func _ready():
	thread = Thread.new()
	if unit_class == null:
		change_class(data.defaultclass, true)
	
	#Performance.add_custom_monitor("UnitMovement", move)
	#Performance.add_custom_monitor("UnitThink", think)
	#Performance.add_custom_monitor("UnitFight", fight)
	
	wandertimer = randf_range(0, 5)
	
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	shelves.storage.location = self
	shelves.input.location = self
	
	var fists = Attack.new(rules, data.weapons.fists, self)
	fists.key = "fist"
	fists.id = rules.assign_id(fists)
	fists.rules = rules
	#fists.parent = self
	attacks.merge({
		"fist": fists
	})
	add_action(fists, 5)
	make_attack_radius(fists, "fist")
	if weapondata != {}:
		var newattack = Attack.new(rules, weapondata, self)
		newattack.id = rules.assign_id(newattack)
		newattack.rules = rules
		newattack.parent = self
		attacks.merge({
			"main": newattack
		})
		make_attack_radius(newattack, "main")
	
	if weapondata == {}:
		weapondata = data.weapons.fists
	
	if current_task != null:
		set_movement_target(current_task.get_movement())
	
	if allegiance == "player":
		add_clearance(3)
	
	if weapon == null:
		pass
	if attacks.has("main"):
		attack_range = attacks.main.range * attacks.main.range
	else:
		attack_range = attacks.fist.range * attacks.fist.range
	
	var parameters = NavigationPathQueryParameters2D.new()
	working = false
	
	#if prot == null:
		#if equipment["armor"] != null:
			#prot = Protection.new(equipment["armor"].protection)
	
	#load_stats()
	
	if(nickname == null):
		nickname = "placeholder"
	
	#calc_equipment()
	calc_effects()
	
	load_sprite()
	
	create_auras()
	
	set_appearance(appearance)
	
	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	var world_vars = get_node("/root/WorldVariables")
	id = world_vars.assign_id(self)
	seen = {}
	change_target(null)
	#current_task = null
	active = true
	
func load_stats():
	for statname in data.fuels:
		if !stats.fuels.has(statname):
			var statdata = data.fuels[statname]
			var stat = Fuel.new(statdata)
			stat.unit = self
			all_stats.merge({
				statname: stat
			})
			stats.fuels.merge({
				statname: stat
				})
			stat.initial_calc()
	for statname in data.qualities:
		if !stats.qualities.has(statname):
			var statdata = data.qualities[statname]
			var stat = Quality.new(statdata)
			stat.unit = self
			all_stats.merge({
				statname: stat
			})
			stats.qualities.merge({
				statname: stat
			})
			stat.initial_calc()
			#apply_stat(stat)
	for statname in data.skills:
		if !stats.skills.has(statname):
			var statdata = data.skills[statname]
			var stat = Skill.new(statdata)
			stat.unit = self
			all_stats.merge({
				statname: stat
			})
			stats.skills.merge({
				statname: stat
			})
			stat.initial_calc()
	
func change_origin(neworigin):
	unit_origin = neworigin
	for lesson in unit_origin.desired_lessons:
		learn_base(lesson, "origin")
	
func change_class(newclass, instant = false, spawngear = false):
	unit_class = newclass
	roles = newclass.assigned_roles.duplicate()
	aggressive = newclass.aggro
	if instant:
		for lesson in unit_class.desired_lessons:
			learn_base(lesson, "augment")
	if spawngear:
		for slot in newclass.equipment:
			var options = newclass.equipment[slot]
			if options != null:
				var weighted = []
				for option in options:
					var count = options[option]
					for i in count:
						weighted.append(option)
				var rand = randi() % weighted.size()
				var result = weighted[rand]
				equip_base(result, slot)
	#if is_node_ready():
		#start_all_lessons()

func load_data(gamerules, gamedata, unitdata, new = true):
	data = gamedata
	rules = gamerules
	change_origin(data.classes.goon)
		
	aggressive = unitdata.aggressive
	allegiance = unitdata.allegiance
	if allegiance == "coalition":
		breakingandentering = true
	datakey = unitdata.datakey
	appearance = unitdata.sprite
	master = unitdata.master
	for role in unitdata.roles:
		roles.append(role)
	if unitdata.equipment != null:
		for slot in unitdata.equipment:
			var base = unitdata.equipment[slot]
			if base != null:
				var item = Stack.new(rules, base, 1, map)
				item.id = rules.assign_id(item)
				equip(item)
	for ability in unitdata.abilities:
		var count = unitdata.abilities[ability]
		add_ability(ability, count)
	for lesson in unitdata.lessons:
		if unitdata.lessons.has(lesson):
			learn_base(data.upgrades[lesson])
	if unitdata.unitclass != null:
		#var newclass = data.classes[unitdata.unitclass]
		change_class(unitdata.unitclass, new, false)
	if is_node_ready():
		if allegiance == "player":
			add_clearance(3)
			
	firstname = unitdata.firstname
	nickname = unitdata.nickname
	lastname = unitdata.lastname
	needs_name = unitdata.needs_name
			
	load_stats()
	for key in unitdata.stats:
		var statdata = unitdata.stats[key]
		for statkey in statdata:
			var stat = stats[key][statkey]
			stat.value = statdata[statkey]
			#apply_stat(stat)
	calc_scaling()

func clear_clothes():
	for key in clothingsprites:
		var newsprite = clothingsprites[key]
		var spriteparent = newsprite.get_parent()
		if spriteparent != null:
			newsprite.get_parent().remove_child(newsprite)

func set_appearance (newappearance):
	appearance = newappearance
	
	clear_clothes()
	
	for slot in equipment:
		if equipment[slot] != null:
			var newsprite = Sprite2D.new()
			newsprite.texture = load("res://art/" + equipment[slot].base.wearsprite + ".png")
			clothingsprites.merge({
				slot: newsprite
			})
			if slot == "weapon":
				weaponsprites.add_child(newsprite)
			elif slot == "head":
				headsprites.add_child(newsprite)
			else:
				bodysprites.add_child(newsprite)
	if is_node_ready():
		load_sprite()
	
func load_sprite():
	#var sprite_path = "res://art/" + appearance + ".png"
	#print("loaded:")
	#print(sprite_path)
	#var image = Image.load_from_file(sprite_path)
	#if(image == null):
	#	image = Image.load_from_file("res://art/caution.png")
	#var sprite_texture = ImageTexture.create_from_image(image)
	#unitsprite.texture = sprite_texture
	pass

func get_concealment():
	return 0

func set_allegiance (side):
	allegiance = side

func send_home():
	leave_map()
	var transport = Transport.new(rules)
	transport.id = rules.assign_id(transport)
	rules.transports.merge({
		transport.id: transport
	})
	transport.needs_placement = false
	await transport.set_target(rules.home)
	await transport.store_unit(self)
	transport.moving = true
	
func leave_map():
	if map != null:
		drop_task()
		map.remove_unit(self)

func spawn():
	on_map = true
	calc_scaling()
	movement_path = null
	targetable = true
	if new:
		if needs_name:
			generate_name()
		generate_skintone()
		new = false
	#print("Spawned next to:")
	#print(vision.get_overlapping_bodies())
	
	if faction != null:
		if faction.color != null:
			chesttoner.modulate = faction.color
	#legtoner.modulate = Color.BLACK
	
	
	
	beam = beamscene.instantiate()
	beam.caster = self
	var nearby = visioncone.get_overlap()
	var hearby = hearing.get_overlapping_bodies()
	for body in hearby:
		if body.entity() == "UNIT":
			_on_hearing_radius_body_entered(body)
	for body in nearby:
		if body.entity() == "UNIT":
			see(body)
			body.see(self)
	map.store_unit(self)
	rules.world_units.merge({
		id: self
	})
	can_interact.merge({
		id: self
	})
	add_child(beam)
	halt()
	start_idle()
	spawned = true
	current_target = null
	scan_for_hostile()
	
# ****
# Combat Tergeting Functions
# ****

func get_target(targets):
	var best = {"-1": null}
	var bestweight = 9223372036854775807
	for target in targets.keys():
		var unit = targets.get(target)
		if unit.entity() == "UNIT":
			var weight = global_position.distance_squared_to(unit.global_position)
			#if unit.dead:
				#seen.erase(target)
			#else:
			#	if verbose:
			#		print(target)
			if weight < bestweight && !unit.dead && unit.allegiance != allegiance:
				best = {target: unit}
				bestweight = weight
	return best
	
func compare_target(target):
	var weight = global_position.distance_squared_to(target.global_position)
	var bestweight
	if current_target != null:
		bestweight = global_position.distance_squared_to(current_target.global_position)
	else:
		bestweight = 10000000000
	if weight < bestweight && !target.dead && target.allegiance != allegiance:
		return true
	else:
		return false
		
func get_combat_position():
	pass

func start_combat():
	prog.visible = true
	#prog.max_value = weapon.aimtime + weapon.readytime
	#prog.value = weapon.countdown
	if !combat:
		combat = true
	
func stop_combat():
	moving = true
	flee_target = null
	prog.visible = false
	if combat:
		if !navigation_finished:
			if current_task == null:
				if !forced_movement:
					halt()
		idle = false
		combat = false

func run_from_hostiles():
	if !hostiles.is_empty() || !enemies.is_empty():
		var closest = quadtree.closest_to(hostiles, true)
		if closest.object != null:
			flee_target = closest.object.global_position
			return true
		else:
			flee_target = null
			return false
	else:
		flee_target = null
		return false
			
func scan_one_hostile(unit):
	scantimer = 10.0
	if aggressive:
		if compare_target(unit):
			change_target(unit)
	else:
		if compare_target(unit):
			flee_target = unit.global_position

func scan_for_hostile():
	scantimer = 10
	if !aggressive && aggtype == "defensive":
		if targeted_by != {}:
			scan_targets(targeted_by)
	elif(!hostiles.is_empty()):
		scan_targets(hostiles)
	elif !enemies.is_empty() && warcriminal:
		scan_targets(enemies)
	else:
		change_target(null)
		#if current_task == null:
			#halt()
		next_target = null
		return false

func scan_targets(targets):
	if verbose:
		print(next_target)
	if quadtree == null:
		await map.unittree.insert(self)
	elif quadtree != null:
		scantimer = 10.0
		var best = await quadtree.closest_to(targets, false)
		if(best != null):
			#next_target = best.object
			change_target(best.object)
			alert_friends(best.object)
			if verbose:
				print(seen)
				print(current_target)
				print("Pursuing " + current_target.id + " at " + String.num(current_target.global_position.x) + ", " + String.num(current_target.global_position.y))
			return true
		else:
			next_target = null
			return false

func alert_friends(target, alerted = {}):
	if target != null:
		for key in heard:
			if !alerted.has(key):
				var unit = heard[key]
				alerted.merge({
					key: unit
				})
				if unit.allegiance == allegiance:
					var can = true
					#if unit.current_target != null:
					if unit.current_task != null:
						if unit.current_task is KillTask:
							if unit.current_task.object == target:
								can = false
					if unit.current_target == target:
						can = false
					if can:
						await unit.be_alerted(target, alerted)
						#await unit.alert_friends(target, alerted)

func change_target(target):
	if current_target != null:
		current_target.be_untargeted(self)
		halt()
	current_target = target
	if target != null:
		current_target.be_targeted(self)
	else:
		halt()
	alert_friends(target)

#****
#Combat Attack/Defense Functions
#****

func break_order(target):
	var task = DestroyTask.new(target)
	drop_task()
	update_task(task)

func break_target(target):
	target_furniture = target



func fire_action_ground(action, target):
	#if action.in_range(target):
	var can = true
	#if action is Spell:
		#can = action.check_conditions(target)
	if can:
		spend_stat("attention", action.focus_cost * -1)
		action_visuals(action, target)
		action.fire_at(target)
		if action.cast_time != 0:
			begin_cast(action)
		return true
	#return false

func fire_action(action, target):
	if action.in_range(target.global_position):
		var can = true
		if action is Spell:
			can = action.check_conditions(target)
		if can:
			spend_stat("attention", action.focus_cost * -1)
			action_visuals(action, target.global_position)
			action.fire_at(target, global_position)
			if action.cast_time != 0:
				begin_cast(action)
			return true
	return false

func action_visuals(action, targetpos):
	if action.animation != "":
		animplayer.play(action.animation)
	for bubble in action.bubbles:
		rules.make_soundbubble(bubble, position)

func begin_cast(action):
	halt()
	casting_action = action
	casting_timer = action.cast_time
	
func finish_cast():
	casting_action = null
	casting_timer = 0.0
	animplayer.play("RESET")
	
func cast_sequence(action, target, delta):
	#action.cast(delta)
	casting_timer -= delta
	if casting_timer <= 0:
		finish_cast()

func fight_target(target, delta):
	var result = null
	
	if target != null:
		var distance = global_position.distance_squared_to(target.global_position)
		var currweapon
		var radius
		var attackname = get_weapon_against(target)
		currweapon = attacks[attackname]
		radius = attackshapes[attackname]
		if target.dead:
			if current_task == null:
				halt()
			target = null
			target_furniture = null
			change_target(null)
			scan_for_hostile()
		else:
		#elif radius.contains(target.id):
			if distance <= preferred_range:# && radius.contains(target.id):
				if current_task == null && moving:
					halt()
			elif !target.dead && !currweapon.attacking && !holding:
				if current_task == null:
					pursue_target(target)
			#attack(currweapon, target, delta, distance)
		#elif !target.dead && !holding:
			#currweapon.time = 0
			#if current_task == null:
				#pursue_target(target)
		#else:
			#pass
			#halt()
	else:
		scan_for_hostile()
		#fight(delta)

func combat_round(delta):
	start_combat()
	if current_task != null:
		if current_task.fragile || !current_task.during_combat:
			drop_task()
	if scantimer <= 0:
		scan_for_hostile()
	else:
		scantimer -= delta
	if current_target != null:
		fight_target(current_target, delta)
	else:
		scan_for_hostile()

func fight(delta):
	var start = Time.get_ticks_usec()
	
	enemies.erase(null)
	hostiles.erase(null)
	if current_target != null:
		if !current_target.targetable:
			change_target(null)
	try_actions(delta)
	if aggressive && aggression_active && !forced_movement:
		var has_hostiles = !hostiles.is_empty()
		var has_enemies = !enemies.is_empty()
		if has_hostiles || (has_enemies && warcriminal):
			combat_round(delta)
		elif target_furniture != null:
			stop_combat()
			fight_target(target_furniture, delta)
		#elif target_furniture != null:
			#fight_target(target_furniture, delta)
		elif aggression_active:
			stop_combat()
	elif !forced_movement:
		if targeted_by != {} && aggression_active :
			combat_round(delta)
		else:
			var newcombat = !enemies.is_empty() || !hostiles.is_empty()
			if newcombat:
				if fleetimer < 0:
					if run_from_hostiles():
						if flee_target != null:
							flee()
				else:
					fleetimer -= delta
				if flee_target != null:
					start_combat()
					if current_task != null:
						if !current_task.during_combat:
							drop_task()
				else:
					stop_combat()
			elif target_furniture != null:
				stop_combat()
				fight_target(target_furniture, delta)
			else:
				stop_combat()
		if flee_target == null && current_target == null:
			stop_combat()
	var end = Time.get_ticks_usec()
	var time = (end-start)/1000000.0
	#print("time " + id + " spent in fight function: %s" % [time])

func total_evasion():
	var bonus = mods.ret("evasion")
	return bonus + evasion
	
func sustain_actions(delta):
	var result = 0
	for spell in toggled_spells:
		#var spell = toggled_spells[key]
		var sustainval = spell.focus_cost * delta
		result -= sustainval
		
		if stats.fuels.attention.value <= sustainval:
			toggle_spell_off(spell)
		else:
			stats.fuels.attention.spend(sustainval*-1)
	return result


#func attack(currweapon, target, delta, range):
#	if currweapon.attacking:
#		#moving = false
#		pass
#	else:
#		#moving = true
#		pass
#	var try = currweapon.try_attack(delta)
#	if(try == 0):
#		hide_from_everyone()
#		var atk = currweapon.attack(delta)
#		if atk == 2:
#			#gain_experience("combat", currweapon.experience)
#			var accuracy = baseaccuracy + currweapon.accuracy
#			for mod in currweapon.accmods:
#				accuracy += mods.ret(mod)
#			var critchance = 5
#			accuracy -= target.total_evasion()
#			var extra = accuracy - 100
#			var bonus = extra % 10
#			extra -= bonus
#			critchance += extra/10
#			if accuracy < 10:
#				accuracy = 10
#			#elif accuracy > 90:
#				#accuracy = 90
#			pass
#			var hit = randi() % 100
#			if hit < accuracy:
#				for anim in currweapon.animations:
#					map.visual_effect(anim, position, target.position)
#				for damage in currweapon.damage:
#					currweapon.roll_damage(damage)
#				for mod in currweapon.dammods:
#					var percent = mods.ret(mod)
#					currweapon.percent_to_all(percent)
#				currweapon.last_shot_range = range
#				rules.trigger("damage_rolled", target, currweapon)
#				var damages = currweapon.get_all_damages()
#				for type in damages:
#					var damage = damages[type]
#					var total = 0.0
#					for stat in damage:
#						var amount = damage[stat]
#						total += amount
#						if target.defend(currweapon, type, stat):
#							#target.number_popup(total)
#							if verbose:
#								print(nickname + id + "COMBATRESULT: Victory!")
#							seen.erase(target.id)
#							combat = false
#							fighting = false
#							change_target(null)
#							scan_for_hostile()
#						if target != null:
#							pass
#							#target.number_popup(total)
#				rules.trigger("attack_hit", target, currweapon)
#					#if target.defend(damage):
#					#	
#			else:
#				print("Miss")
#		elif atk == 0:
#			currweapon.reset()
			
	#prog.value = weapon.countdown
	
func untarget(target):
	#unsee(target)
	combat = false
	fighting = false
	change_target(null)
	scan_for_hostile()
	
func fire_weapon(weapon, target):
	if target != null:
		#gain_experience("combat", weapon.experience)
		var accuracy = baseaccuracy + weapon.accuracy
		for mod in weapon.accmods:
			accuracy += mods.ret(mod)
		var critchance = 5
		accuracy -= target.total_evasion()
		var extra = accuracy - 100
		var bonus = extra % 10
		extra -= bonus
		critchance += extra/10
		if accuracy < 10:
			accuracy = 10
		#elif accuracy > 90:
			#accuracy = 90
		pass
		var hit = randi() % 100
		if hit < accuracy:
			for anim in weapon.visuals:
				if anim.on_success:
					map.visual_effect(anim.visual, position, target.position)
			for damage in weapon.damage:
				weapon.roll_damage(damage)
			for mod in weapon.dammods:
				var percent = mods.ret(mod)
				weapon.percent_to_all(percent)
			weapon.last_shot_range = weapon.range
			rules.trigger("damage_rolled", target, weapon)
			var damages = weapon.get_all_damages()
			for type in damages:
				var damage = damages[type]
				var total = 0.0
				for stat in damage:
					var amount = damage[stat]
					total += amount
					if target.defend(weapon, type, stat):
						#target.number_popup(total)
						if verbose:
							print(nickname + id + "COMBATRESULT: Victory!")
						seen.erase(target.id)
						combat = false
						fighting = false
						change_target(null)
						scan_for_hostile()
					if target != null:
						pass
						#target.number_popup(total)
			rules.trigger("attack_hit", target, weapon)
		else:
			var xdir = randi() % 2
			var ydir = randi() % 2
			if xdir == 0:
				xdir -= 1
			if ydir == 0:
				ydir -= 1
			var missx = 32 * ydir + ((randi() % 32) - 16)
			var missy = 32 * xdir + ((randi() % 32) - 16)
			var misspos = target.position + Vector2(missx, missy)
			for anim in weapon.visuals:
				if anim.on_fail:
					map.visual_effect(anim.visual, position, misspos)
			make_popup("Miss!")
			rules.trigger("attack_miss", target, weapon)
						#if target.defend(damage):
	
func defend(attack, type, stat):
	var damage = attack.total_damage(type)[stat]
	var piercing = attack.bonus_ap
	var protection
	if defense != null:
		#Armor currently = min - (min+variance)
		#armor should be DAM100, or the amount of damage (with AP) an attack must do to deal 100% of its normal damage
		#when below armor, damage reduction is equal to damage/armor
		#armor still should have variance
		#Critical hits have double armor pen values
		var armor = defense.get_defense(damage, piercing, type)
		protection = armor
	else:
		protection = 0.0
	damage = float(damage - protection)
	if damage < 0.0:
		damage = 0.0
	number_popup(damage)
	if verbose:
		print(nickname + id + "COMBATRESULT: Attacked! Weapon damage: " + String.num(damage))
	if(damage(stat, damage)):
		if stat == "health":
			if die(attack.unit):
				return true
	else:
		return false
	
func pursue(target):
	return
	
func damage(fuel, amount):
	
	if fuel == "health":
		if encounter != null:
			encounter.bravery -= amount
	if !dead:
		stats.fuels[fuel].spend(amount * -1)
		if(stats.fuels[fuel].value <= 0):
			return true
		else:
			return false
	else:
		return false
	
func number_popup(value, color = "damage"):
	var str = String.num(value)
	make_popup(str, color)
	
func make_popup(str, color = "damage"):
	var randx = randf_range(-16, 16)
	var randy = randf_range(-32, 0)
	var pos = global_position + Vector2(randx, randy)
	rules.make_popup(str, pos, color)
	
func finish_combat():
	if !forced_movement:
		halt()
	
func heal_or_hurt(amount):
	health = health + amount

#****
#Movement Functions
#****

func in_range(enemy):
	pass
	
func has_attack_order(enemy):
	for task in movement:
		if task.object == enemy:
			return true
	return false

func be_alerted(enemy, alerted = {}):
	var can = true
	if current_target != null:
		if current_target != enemy:
			var newdistance = global_position.distance_squared_to(enemy.global_position)
			var oldistance = global_position.distance_squared_to(current_target.global_position)
			if newdistance > oldistance:
				can = false
	if has_attack_order(enemy):
		can = false
	if can:
		attack_order(enemy, alerted)
	else:
		pass

func attack_order(enemy, alerted = {}):
	if !in_sight.has(enemy.id):
		var newtask = KillTask.new(enemy)
		newtask.personal = true
		var replaced = false
		if current_task != null:
			if current_task.personal:
				update_task(newtask)
				replaced = true
		if !replaced:
			movement.push_front(newtask)
		alert_friends(enemy, alerted)
	else:
		change_target(enemy)

func move_order(square, final, queued = true):
	var order = MoveTask.new(square, final)
	if queued:
		queue.push_back(order)
	else:
		update_task(order)


func get_next_path_square():
	if movement_path != null && movement_path.path.size() != 0:
		navigation_finished = false
		var next = movement_path.path[0]
		if global_position.distance_squared_to(next.cell.global_position) <= 4:
			movement_path.path.pop_at(0)
			return get_next_path_square()
		else:
			return next
	else:
		navigation_finished = true
		return null

func traverse_path(path, dest, link, velocity, delta):
	var square = link.square
	var navigable = square.can_navigate(self)
	if navigable == 1:
		pass
	if navigable == 0 || navigable == 1:
		var next_path_position = dest.global_position
		var next_position = global_position.move_toward(next_path_position, movement_delta)
		var overflow = next_position - next_path_position
		var direct_vector = next_path_position - global_position
		var res = get_next_path_square()
		if overflow.abs() > direct_vector.abs():
			global_position = global_position.move_toward(direct_vector, delta)
			#path.index += 1
			traverse_path(path, res.cell, res.link, overflow, delta)
		else:
			global_position = next_position
	else:
		pass
	return navigable
	#if overflow
	

func _integrate_forces(state):
	pass
	#move(state.step)

	
func relax(delta):
	#If current_target != null, relax towards target
	pass

func push_away_from(pos, amount):
	if !forced_movement:
		var direction = pos.direction_to(global_position)
		direction *= amount
		#var newpos = direction + global_position
		pushcast.target_position = direction
		pushcast.force_raycast_update()
		var targetpos: Vector2
		if pushcast.is_colliding():
			targetpos = pushcast.get_collision_point() - global_position
		else:
			targetpos = direction
		push(targetpos, pos)
	
func push(amount, origin):
	apply_impulse(amount, origin)
	
#works similar to set_movement_target, but applied forced movement
#forced movement follows slightly different rules. unit cannot change move target or do anything until it stops
func push_to(point):
	forced_movement = true
	apply_impulse(point * 5)
	#set_movement_target(point)

func move(delta):
	pass
	if moving && !nav.is_navigation_finished():
		if current_task != null:
			current_speed = current_task.speed
		else:
			current_speed = "run"
		var current = speeds[current_speed]
		movement_delta = current * delta
		var navresult: NavigationPathQueryResult2D = nav.get_current_navigation_result()
		var i: int = nav.get_current_navigation_path_index()
		var point: Vector2 = navresult.path[i]
		var square: Square = instance_from_id(navresult.path_owner_ids[i])
		#nav.avoidance_priority = 0.5
		
		var can_enter: int = square.can_navigate(self)
		if can_enter == 0 || can_enter == 1:
			var new_velocity: Vector2 = global_position.direction_to(point) * movement_delta
			#global_position = global_position.move_toward(global_position + new_velocity, movement_delta)
			if nav.avoidance_enabled:
				nav.velocity = new_velocity
			else:
				_on_velocity_computed(new_velocity)
			#apply_impulse(new_velocity)
			#velocity = new_velocity
			#move_and_slide()
			#var collision = move_and_collide(velocity)
			#if collision:
			#if collision:
				#var collider = collision.get_collider()
				#pass
				#for j in get_slide_collision_count():
					#var collision = get_slide_collision(j)
					#pass
		else:
			halt()
			if !forced_movement:
				break_order(square.door.furniture)
		pass
	else:
		pass
	if nav.is_navigation_finished():
		forced_movement = false
		#nav.avoidance_priority = 1.0
	#var current_agent_position: Vector2 = global_position
	#var next_path_result = get_next_path_square()
	
	#if next_path_result != null:
		#if !animplayer.is_playing():
			#animplayer.play("walk")
		#var next_path_cell = next_path_result.cell
		#var next_path_link = next_path_result.link
		#var next_path_square = next_path_link.square
		#var navigable = next_path_square.can_navigate(self)
		#if navigable == 0 || navigable == 1:
			#var next_path_position = next_path_square.global_position
			#print(current_agent_position)
			#print(next_path_position)
			#next_path_position.y = 0
			#var new_velocity: Vector2 = global_position.direction_to(next_path_position)
			#movement_delta = movement_speed * delta
			#if modifiers.has("haste"):
				#movement_delta += (movement_delta * (modifiers.haste / 100.0))
			#new_velocity *= movement_delta
			#if new_velocity > next_path_position:
				#new_velocity = next_path_position
			#new_velocity = new_velocity.normalized()
			#velocity = new_velocity
			#var result = traverse_path(movement_path, next_path_cell, next_path_link, new_velocity, movement_delta)
			#if next_path_square.door != null:
				#pass
			#if result == 0 || result == 1:
				#pass
			#elif result == 2:
				#halt()
				#break_target(next_path_square.footprint.content)
			#else:
				#pass
		#elif navigable == 2:
			#halt()
			#break_order(next_path_square.footprint.content)
		#else:
			#animplayer.play("RESET")
	#elif movement_path != null:
		#if position.distance_squared_to(movement_path.final) > 4:
			#slide_to(movement_path.final, delta)
		#else:
			#halt()
	#else:
		#pass
		#animplayer.play("RESET")
	
func slide_to(point, delta):
	global_position = global_position.move_toward(point, delta)
	
#func get_vector():
	#var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	#var new_velocity: Vector2 = position.direction_to(next_path_position)
	#return new_velocity

func get_square(origin = null, reserving = false, spotname = "interact"):
	return current_square

func pursue_target(target):
	
	if(target != null):
		var in_pursuit = false
		#if movement_path != null:
			#if movement_path.final == target.global_position:
				#in_pursuit = true
		if !in_pursuit:
			set_movement_target(target.global_position)
			if movement_path != null:
				movement_path.final = target.global_position
		
func pursue_objective():
	if encounter != null:
		if encounter.objective != null:
			set_movement_target(encounter.objective.get_square(self, false).get_cell())
			
			
#if objective is DESTROY or SABOTAGE, target the same objective as other units.
#func find_objective():
		
func flee():
	fleetimer = 0.2
	var best = null
	var bestweight = -999999999999999999.000
	var weight = 0
	var pos = null
	var besti = 0
	for i in rays.size():
		var ray = rays[i]
		pos = ray.get_collision_point()
		weight = flee_target.distance_squared_to(pos) - (global_position.distance_squared_to(pos) - flee_target.distance_squared_to(pos))
		var square = map.get_square_for_pos(pos)
		if movement_square == square:
			weight += (weight * 0.50)
		if weight > bestweight:
			best = pos
			bestweight = weight
			besti = i
			if i > 0:
				pass
	if(best != null):
		var square = map.get_square_for_pos(best)
		movement_square = square
		set_movement_target(square.global_position)

func set_movement_target(movement_target: Vector2):
	moving = true
	if movement_target != null:
		#if verbose:
		#for square in path:
		
		
		
		
		if movement_target == global_position:
			navigation_finished = true
			#return
		else:
			navigation_finished = false
		
		if movement_target != null:
			nav.set_target_position(movement_target)
			#var next = nav.get_current_navigation_result()
			#var can = nav.is_target_reachable()
			pass
			#if result != null:
				#movement_path = Navpath.new(result, movement_target.position)
			#else:
				#pass
		else:
			pass

func finish_movement():
	pass

func halt():
	if current_cell != null:
		target_cell = current_cell
		target_cell.final_pos.merge({
			id: self
		})
	forced_movement = false
	animplayer.play("RESET")
	#movement_path = null
	set_movement_target(global_position)
	moving = false
	
#****
#Stat Functions
#****
	
func change_stat(statname, amount):
		var stat = all_stats[statname]
		stat.spend(amount)
		#apply_stat(stat)
		
func spend_stat(statname, amount):
	var stat = all_stats[statname]
	stat.spend(amount)
		
func learn_skill(skill, amount):
	change_stat(skill, amount)
		
func remove_resources(resources, shelf):
	for key in resources:
		var count = resources[key]
		shelves[shelf].remove(key.id, count)
		
#ACCEPTS HASTE MODS AND EFFICIENCY MODS. POSITIVE MODS (HASTE) INCREASE DRAIN NEGATIVE (EFFICIENCY) DECREASES
func apply_drain(drains, delta, mods_used = {}):
	var totalmod = 0
	for key in mods_used:
		var modifyamount = mods_used[key]
		var modpercent = modifyamount / 100
		var modifier = mods.ret(key)
		modifier *= modpercent
		var totalpercent = modifier / 100
		totalmod += totalpercent
	for stat in drains.keys():
		var amount = drains.get(stat) * delta
		var bonusamount = amount * totalmod
		var total = (amount + bonusamount) * -1
		change_stat(stat, total)

func apply_healing(stat, amount):
	all_stats[stat].heal_damage(amount)

func train_skill(delta, skillname, amount):
	var total = delta * amount
	if stats.skills.has(skillname):
		stats.skills[skillname].modify(total)
	#apply_stat(stats.skills[skillname])
	
func rest_and_recuperation(need):
	var found = false
	var furniture = await suitable_rest(need)
	if furniture != null:
		var task = furniture.make_task_for_unit(self)
		if task != null:
			rnr = true
			task.rnr = true
			filling.merge({
				need: stats.fuels[need]
			})
			#found = await furniture.primary_job.assign_actor(self, "interact")
			if(current_task != null && !(current_task is GrabTask) && current_task.type != "restore"):
				drop_task()
			
			return true
			
func think_about_fulfilment():
	filling = []
	if current_task.job != null:
		for stat in current_task.job.drains.keys():
			if(stats.fuels.has(stat)):
				filling.push_back(stats.fuels.get(stat))
	
func get_needs():
	var lowstats = {}
	for stat in stats.fuels.keys():
		var ref = stats.fuels.get(stat)
		if !ref.autofill:
			var value = ref.value
			var need = ref.max
			if(value < ref.target):
				lowstats.merge({stat: need})
	return lowstats
	
func check_damage():
	for key in damage_thresholds:
		var value = damage_thresholds[key]
		if value <= stats.fuels[key].damage:
			return key
	for key in value_thresholds:
		var value = value_thresholds[key]
		if value >= stats.fuels[key].value:
			return key
	return ""
			
func check_soft_damage():
	for key in soft_damage_thresholds:
		var value = soft_damage_thresholds[key]
		if value <= stats.fuels[key].damage:
			return key
	for key in soft_value_thresholds:
		var value = soft_value_thresholds[key]
		if value >= stats.fuels[key].value:
			return key
	return ""
	
func suitable_rest(need):
	var weights = {}
	var bestfurniture = null
	var bestdistance = 10000000
	var best = {}
	var potential = map.get_restores(need, self)
	if(potential != {}):
		best = await map.furntree.closest(global_position, potential, false)
	if best != {}:
		return best.object
	else:
		return null
		
		
		
func suitable_prison():
	var weights = {}
	var bestfurniture = null
	var bestdistance = 10000000
	var best = {}
	var potential = map.get_prisons(self)
	if(potential != {}):
		best = await map.furntree.closest(global_position, potential, false)
		
	if best != {}:
		return best.object
	else:
		return null
		
	
func need_satisfaction():
	needs = get_needs()
	if needs.is_empty():
		rnr = false

	
#****
#Upgrade Functions
#****

func find_upgrade(base):
	for i in upgrades.size():
		var upgrade = upgrades[i]
		if upgrade.base == base:
			return i
	return -1

func check_origin():
	if unit_origin != null:
		for lesson in unit_origin.desired_lessons:
			if !upgrading.lesson.has(lesson.title) && find_upgrade(lesson) == -1:
				learn_base(lesson, "lesson")

func check_class():
	if unit_origin != null:
		for lesson in unit_origin.desired_lessons:
			if !upgrading.lesson.has(lesson.title) && find_upgrade(lesson) == -1:
				learn_base(lesson, "lesson")
	for lesson in unit_class.desired_lessons:
		if !upgrading.lesson.has(lesson.title) && upgrades.find(lesson) == -1:
			if upgrading.lesson.size() + used_auglimits[lesson.limit] < auglimits.lesson:
				start_lesson(lesson)
			else:
				pass
	for key in upgrading.lesson:
		var lesson = upgrading.lesson[key]
		if lesson.task == null:
			var can = lesson.can_learn()
			if can:
				go_learn(lesson)
	for key in upgrading.augment:
		var lesson = upgrading.augment[key]
		if lesson.task == null:
			var can = lesson.can_learn()
			if can:
				go_learn(lesson)
	for slot in unit_class.equipment:
		if !equip_overrides.has(slot) || equip_overrides[slot] == null:
			if equipment.has(slot):
				if !wants_equipment[slot]:
					var options = unit_class.equipment[slot]
					if options != null:
						var replacing = true
						if equipment[slot] != null:
							if options.has(equipment[slot].base):
								replacing = false
						if replacing:
							if options != {}:
								var found = false
								for base in options:
									if has_base_equipped(base):
										found = true
									var weight = options[base]
									if !found:
										var item = find_and_equip(base)
										if item != null:
											#item.reserved_count += 1
											found = true
											#wants_equipment[slot] = true
	for slot in equip_overrides:
		var base = equip_overrides[slot]
		if base != null:
			if equipment.has(slot):
				if !wants_equipment[slot]:
					if equipment[slot] == null || equipment[slot].base != equip_overrides[slot]:
						find_and_equip(base)
	
#Lessons learned & known not in the class or overrides, capable of being replaced. Returns bases.
func replaceable_lessons():
	for key in upgrading.lesson:
		var lesson = upgrading.lesson[key]

func needs_lesson(base):
	var wants = false
	if unit_class != null:
		if unit_class.desired_lessons.find(base) != -1:
			wants = true
	if extra_lessons.has(base.key):
		wants = true
	return wants

func go_learn(lesson):
	var target = await map.find_teacher(lesson.base.taught_by, self)
	if target != null:
		if target.object != null:
			lesson.start_lesson()
			
			var object = target.object
			object.in_use = true
			lesson.site = object
			#lesson.make_task_for_unit(self)
			var task = LearnTask.new("learning", object.spots.interact[0].global_position, lesson, object)
			task.actor = self
			queue.push_back(task)
	
func start_all_lessons():
	for lesson in unit_class.desired_lessons:
		if !upgrading.lesson.has(lesson.name):
			if upgrades.size() + upgrading.lesson.size() <= lessonmax:
				start_lesson(lesson)
			else:
				pass

#region Abilities
func add_ability_by_name(abname, count):
	if data.abilities.has(abname):
		var base = data.abilities[abname]
		add_ability(base, count)
		
func remove_ability_by_name(abname, count):
	if data.abilities.has(abname):
		var base = data.abilities[abname]
		remove_ability(base, count)

func add_ability(base, count, initial_state = false):
	if abilities.has(base.key):
		var ability = abilities[base.key]
		ability.count += count
		ability.state = initial_state
		if ability.state || !ability.base.toggling:
			for newbase in ability.base.effects:
				var newcount = ability.base.effects[newbase] * count
				apply_effect(newbase, newcount)
	else:
		var ability = Ability.new(base, self)
		if base is ActiveAbilityBase:
			#active_abilities.merge({
			#	ability.base.key: ability
			#})
			#add_action(ability, 3)
			pass
		ability.state = initial_state
		ability.count = count
		abilities.merge({
			ability.base.key: ability
		})
		if ability.state || !ability.base.toggling:
			for newbase in ability.base.effects:
				var newcount = ability.base.effects[newbase] * count
				apply_effect(newbase, newcount)
	
		

		
func remove_ability(ability, count):
	if abilities.has(ability):
		var newcount = abilities[ability] - count
		if newcount >= 0:
			for effect in ability.effects:
				remove_effect(effect, ability.effects[effect])
			abilities.merge({
				ability: newcount
			}, true)
		else:
			disable_ability(ability)
			abilities.erase(ability)
			remove_action(ability)
	
func toggle_ability(ability, state):
	if state != ability.state:
		ability.state = state
		if state:
			enable_ability(ability)
		else:
			disable_ability(ability)
	
func enable_ability(ability):
	if ability.timed || ability.base is ActiveAbilityBase:
		#active_abilities.merge({
		#	ability.base.key: ability
		#})
		actions.append(ability)
	
	for effect in ability.base.effects:
		apply_effect(effect, (ability.base.effects[effect] * ability.count))
	#for weapon in ability.base.attacks:
		#add_weapon(weapon, "ability")
	
func disable_ability(ability):
	active_abilities.erase(ability.base.key)
	var i = actions.find(ability)
	actions.pop_at(i)
	for effect in ability.base.effects:
		remove_effect(effect, ability.base.effects[effect])
#endregion
		
#region Triggers
func remove_trigger(oldtrigger):
	if triggers.has(oldtrigger.time):
		triggers[oldtrigger.time].pop_at(triggers[oldtrigger.time].find(oldtrigger))
		if triggers[oldtrigger.time] == []:
			triggers.erase(oldtrigger.time)
		
		
func add_trigger(time, triggerdata):
	var newtrigger = Trigger.new(data, triggerdata)
	newtrigger.time = time
	#trigger.rules = rules
	#trigger.parent = self
	triggers.merge({
		time: []
	})
	triggers[time].append(newtrigger)
	return newtrigger
#endregion
		
#region Actions
func add_action(action, priority):
	actions.merge({
		priority: []
	})
	action.unit = self
	actions[priority].append(action)
	action_priority.insert_action(action, priority)
	calc_range()
	
func remove_action(action):
	var i = actions.find(action)

func add_weapon(weapon = "", slot = "", count = 1):
	for num in count:
		var attack = Attack.new(rules, data.weapons[weapon], self, count)
		attack.key = weapon
		#attack.unit = self
		attack.rules = rules
		attacks.merge({
			weapon: attack
		})
		add_action(attack, 1)
		make_attack_radius(attack, slot)
		attack_priority.push_front(weapon)
		if attack_slots.main == "":
			attack_slots.main = weapon

func add_spell(spellname = "", count = 1):
	for num in count:
		var spelldata = data.spells[spellname]
		var spell
		if !spelldata.has("type"):
			spell = Spell.new(data, spelldata, self)
		else:
			var spelltype = rules.script_map[spelldata.type]
			spell = spelltype.new(data, spelldata, self)
		spell.key = spellname
		spell.unit = self
		spell.rules = rules
		add_action(spell, 1)
	
func remove_weapon(weapon = "", count = 1):
	for num in count:
		for i in 100:
			if attacks.has(i):
				var choices = attacks[i]
				for action in choices:
					if action is Attack && action.key == weapon:
						remove_action(action)
						return
func get_weapon_against(target):
	var punching = true
	var attackname = "fist"
	if attacks.has(attack_slots.main):
		if attackshapes[attack_slots.main].contents.has(target.id):
			punching = false
			attackname = attack_slots.main
	if attacks.has(attack_slots.secondary):
		if attackshapes[attack_slots.secondary].contents.has(target.id):
			punching = false
			attackname = attack_slots.secondary
	#elif attacks.has("natural"):
		#attackname = "natural"
	return attackname
		

func try_actions(delta):
	for i in 100:
		if actions.has(i):
			for action in actions[i]:
				action.cool_down(delta)
				
	var waiting = false
	
	if casting_action == null && !forced_movement:
		for i in range(queued_actions.size()-1,-1,-1):
			var action = queued_actions[i]
			var fired = try_action(action, delta, true)
			if fired:
				queued_actions.pop_at(i)
			else:
				waiting = true
		if !waiting:
			var prioritised_actions = action_priority.actions
			for action in prioritised_actions:
				#try_cast(action)
				try_action(action, delta)
	else:
		cast_sequence(casting_action, casting_target, delta)

func try_action(action, delta, queued = false):
	if action.time == 0 && (action.autocast || queued):
		if action.has_focus():
			var target
			if action is Attack:
				target = current_target
			elif action is Spell:
				target = action.find_target(self)
				pass
			if target != null:
				return fire_action(action, target)
	return false

#endregion
	
func calc_range():
	var minval = 9999999999999
	var min
	var found = false
	for i in 100:
		if actions.has(i):
			for action in actions[i]:
				if action is Attack:
					if action.range < minval:
						minval = action.range
						min = action
						found = true
			if found:
				break
	preferred_range = minval * minval

func overtime_effects(delta):
	for effect in overtime:
		var count = overtime[effect]
		if effect.damage != {}:
			var amount = effect.damage.amount * delta * count * -1
			change_stat(effect.damage.stat, amount)

func add_overtime(effect, count):
	if overtime.has(effect):
		overtime[effect] += count
	else:
		overtime.merge({
			effect: count
		})
	
func remove_overtime(effect, count):
	if overtime.has(effect):
		overtime[effect] -= count
		if overtime[effect] <= 0:
			overtime.erase(effect)
		

	
func apply_effect(effectbase, count):
	if !effectbase.type == "oneshot":
		var effect: Effect
		if effectbase.type == "attack":
			add_weapon(effectbase.attackname, "main", count)
		elif effectbase.type == "spell":
			add_spell(effectbase.spellname, count)
		elif effectbase.type == "armor":
			var prot = data.armors[effectbase.armorname]
			defense.add_protection(prot)
		elif effectbase.type == "overtime":
			add_overtime(effectbase, count)
		if effects.has(effectbase.effname):
			effect = effects[effectbase.effname]
			var newcount = effect.stacks + count
			effect.stacks = newcount
		else:
			effect = Effect.new(self, effectbase, count)
			effects.merge({
				effectbase.effname: effect
			})
			for time in effectbase.triggers:
				var newtriggers = effectbase.triggers[time].duplicate()
				for triggerdata in newtriggers:
					var newtrigger = add_trigger(time, triggerdata)
					#effect.trigger_instances.append(newtrigger)
		calc_effects()
	else:
		pass
	
func remove_effect(effectbase, count):
	if effects.has(effectbase.effname):
		if effectbase.type == "attack":
			remove_weapon(effectbase.attackname, count)
		elif effectbase.type == "armor":
			pass
		elif effectbase.type == "overtime":
			remove_overtime(effectbase, count)
		var effect = effects[effectbase.effname]
		effect.stacks -= count
		if effect.stacks > 0:
			calc_effects()
		else:
			effects.erase(effectbase.effname)
			for key in effectbase.triggers:
				var trigger = effectbase.triggers[key]
				remove_trigger(trigger)
			calc_effects()

func start_lesson(base_lesson):
	if upgrades.find(base_lesson) == -1:
		var newlesson = Lesson.new(base_lesson, rules)
		newlesson.calc_scaling(scaling)
		newlesson.actor = self
		newlesson.id = rules.assign_id(newlesson)
		upgrading[base_lesson.limit].merge({
			base_lesson.name(): newlesson
		}, true)
		newlesson.map = map
		#map.active_lessons.merge({
		#	newlesson.id: newlesson
		#})
	
func add_points(pointname, amount):
	points.merge({
		pointname: 0
	})
	points[pointname] += amount
	
func remove_points(pointname, amount):
	if points.has(pointname):
		points[pointname] -= amount
	if points[pointname] <= 0:
		points.erase(pointname)
	
func learn_lesson(lesson, ignore_picks = false):
	var can = ignore_picks
	if lesson_picks > 0:
		lesson_picks -= 1
		can = true
	if can:
		learn_base(lesson, "lesson")
	
func learn_base(base, source = "nosource"):
	var upgrade = Upgrade.new(base, source)
	upgrades.append(upgrade)
	for key in base.ratings:
		var value = base.ratings[key]
		increase_rating(key, value)
	for key in base.abilities:
		add_ability(key, base.abilities[key])
	upgrading[base.limit].erase(base.title)
	
func unlearn_lesson(lesson):
	if upgrades.find(lesson) != -1:
		for key in lesson.base.abilities:
			remove_ability(key, lesson.base.abilities[key])
		for key in lesson.points:
			var amount = lesson.points[key]
			remove_points(key, amount)
		upgrades.erase(lesson)
	
func apply_buff(buffbase):
	if !buffbase.stacking:
		for buff in buffs:
			if buff.base == buffbase:
				buff.time = buffbase.duration
				return
	var buff = Buff.new(buffbase)
	for effect in buff.base.effects:
		var count = buff.base.effects[effect]
		apply_effect(effect, count)
	buffs.append(buff)
	buff_update.emit(buff)
	buff_added.emit(buff)
	calc_effects()
	
func expire_buff(buff):
	var i = buffs.find(buff)
	for effect in buff.base.effects:
		var count = buff.base.effects[effect]
		remove_effect(effect, count)
	buffs.pop_at(i)
	buff_update.emit(buff)
	buff_removed.emit(buff)
	calc_effects()
	
func calc_effects():
	mods.clear()
	for key in effects:
		var effect = effects[key]
		if effect.base.type == "mod":
			var newmods = effect.base.get_modifiers()
			for modkey in newmods:
				var modifier = newmods[modkey]
				modifier *= effect.stacks
				mods.mod(modkey, modifier)
		elif effect.base.type == "aura":
			var auradata = effect.base.get_aura()
			if !auras.has(effect):
				var aura = aurascene.instantiate()
				aura.make_aura(effect.base)
				auras.merge({
					effect: aura
				})
	if is_node_ready():
		create_auras()
	#for key in known:
	#	var lesson = known[key]
	#	for eff in lesson.effects.modifiers:
	#		var val = lesson.effects[eff]
	#		modifiers.merge({
	#			eff: val
	#		})
		
func create_auras():
	for effect in auras:
		var aura = auras[effect]
		add_child(aura)
		
func ability_palette():
	var pal = []
	for key in abilities:
		var ability = abilities[key]
		var count = ability.count
		pal.append(ability.base.make_power(ability))
	return pal
	
func action_palette():
	var pal = []
	for i in 100:
		if actions.has(i):
			var options = actions[i]
			for action in options:
				#var count = action.count
				pal.append(action.make_power())
	return pal
		
#****
#Task Functions
#****
	
func calc_equipment():
	tools = []
	defense.clear_protection()
	#for slot in equipment:
	#	var item = equipment[slot]
	#	if slot == "weapon":
	#		if item != null:
	#			var newweapon = Attack.new(item.base.attack)
	#			newweapon.rules = rules
	#			newweapon.parent = self
	#			attacks.merge({
	#				"main": newweapon
	#			}, true)
	#			if is_node_ready():
	#				make_attack_radius(newweapon, "main")
	#			attack_range = newweapon.range * newweapon.range
	#	elif slot == "armor" || slot == "head":
	#		if item != null:
	#			var protection = Protection.new(item.base.protection)
	#			defense.add_protection(protection)
	#	else:
	#		if item != null:
	#			pass
				#tools.append(item.tool)
	
	
	
func pickup_and_equip(item):
	var stack = item.location.take_from(item.base, 1)
	stack.location = self
	if stack != null:
		if equip(stack):
			return true
		else:
			drop_item(stack)
	return false
	
func equip_base(base, slot):
	var item = Stack.new(rules, base, 1, map)
	item.rules = rules
	item.id = rules.assign_id(item)
	equip(item)
	
func has_base_equipped(base):
	for item in equipped:
		if item.base == base:
			return true
	return false
	
func get_slot_limit(slot):
	if slot_limits.has(slot):
		return slot_limits[slot]
	return 100000
	
func get_slot_amount(slot):
	if slot_amount.has(slot):
		return slot_amount[slot]
	return 0
	
func get_slots_available(slot):
	var has = get_slot_amount(slot)
	var limit = get_slot_limit(slot)
	return limit - has
	
func is_slot_full(slot):
	var available = get_slots_available(slot)
	if available > 0:
		return false
	else:
		pass
	return true
	
func equip(item):
	if !is_slot_full(item.base.slot):
		#unequip(slot)
		#equipment[slot] = item
		#wants_equipment[slot] = false
		equipped.append(item)
		if map != null:
			map.remove_stack(item)
		for ability in item.base.equip_abilities:
			add_ability(ability, 1)
		#calc_equipment()
		if is_node_ready():
			set_appearance(appearance)
		return true
	else:
		pass
	return false
		
func unequip(item):
	var i = equipped.find(item)	
	if i != -1:
		equipped.pop_at(i)
		for ability in item.base.equip_abilities:
			remove_ability(ability, 1)
		return true
	return false
				
func unequip_and_drop(item):
	unequip(item)
	drop_item(item)
	
func drop_item(item):
	if item != null:
		map.drop_object(item, current_square.x, current_square.y)
	
func pick_up(itemdata):
	item.visible = true
	return true
	
func grab_resource(resource):
	pass
	if resource.item.location.can_interact.has(id):
		if shelves.has(resource.item.base):
			shelves.merge({resource.item.base.id: shelves[resource.item.base.id] + resource.count}, true)
		else:
			shelves.merge({resource.item.base.id: 1}, true)
		return true
	else:
		return false
	
func set_down():
	return true
	
func drop():
	item.drop()
	item.visible = false
	return true
	
func update_task(task):
	end_task()
	current_task = task
	if task != null:
		await task.update_actor(self)
		if is_node_ready():
			var reserving = task.reserving
			#if task is GrabTask || task is TransportTask || task is DestroyTask:
				#reserving = false
			if current_interactzone != null:
				current_interactzone.in_use = false
			#var square = task.get_square(self, reserving, current_task.jobslot)
			var movetarget = task.get_movement()
			current_task.start_job()
			#set_movement_target(current_task.target)
			#if !task is MoveTask:
				#if square != null:
					#set_movement_target(square.cells.center.global_position)
				#else:
					#pass
			#else:
			set_movement_target(movetarget)
		#if(current_task.job != null):
			#current_task.job.actorslots[current_task.jobslot].append(self)
	working = false
	
func end_task():
	if current_task != null:
		if current_task is GrabTask && !current_task.done:
			current_task.item.reserved_count -= current_task.count
		if current_task.object != null:
			if current_task.object is Furniture:
				current_task.object.unreserve_slots(current_task.jobslot)
				if current_task.job != null:
					current_task.job.foundactors -= 1
	
func delete_task(finished = false):
	if current_task != null:
		if current_task is GrabTask:
			pass
		if current_task.rnr:
			rnr = false
		if current_task.stoppable:
			current_task.remove_actor(self)
			if current_task.job != null:
				if current_task.job.action == "finish_sleeping":
					pass
				current_task.job.foundactors -= 1
				map.active_jobs.erase(current_task.job.id)
			clear_interact()
			stop_patrol()
			#if current_task.job != null:
				#map.active_jobs.erase(current_task.job.id)
			end_task()
			if current_task.job != null:
				current_task.job.actorslots = {}
				if current_task.job.location is Furniture:
					current_task.job.location.in_use = false
				current_task.job.started = false
				#current_task.job.task_exists = false
				current_task.job.waiting_for_resource = false
			if current_task.type == "learn":
				if current_task.lesson != null:
					current_task.lesson.task = null
			if queue == []:
				idle = false
			if current_task.type != "restore":
				pass
			current_task = null
			working = false
			
			if !finished:
				pass
			
			if verbose:
				print("job's done")
	
func get_mad():
	aggressive = true
	scan_for_hostile()
	
func drop_storage():
	for key in shelves:
		var shelf = shelves[key]
		for item in shelf.return_stacks():
			drop_from_shelf(item.base, item.count, key)

#Returns the dropped stack
func drop_from_shelf(base, count, shelf):
	var item = shelves[shelf].split(base, count)
	drop_item(item)
	
func drop_task():
	if current_task != null:
		if current_task.stoppable:
			if !current_task.personal && !current_task.for_request:
				#if shelves.storage.contents != {}:
				if current_task is GrabTask:
					drop_from_shelf(current_task.base, current_task.count, "storage")
				current_task.remove_actor(self)
				if current_task.job != null:
					current_task.job.foundactors -= 1
				clear_interact()
				stop_patrol()
				map.taskmaster.add_task(current_task)
				if queue == [] && !combat:
					idle = false
				if verbose:
					print("task dropped")
				working = false
				current_task = null
			else:
				var task = current_task
				#if shelves.storage.contents != {}:
				if current_task is GrabTask:
					drop_from_shelf(current_task.base, current_task.count, "storage")
				delete_task()
				if task.for_request:
					task.job.repush_request()
	
	
func pause_task():
	var oldtask = current_task
	if queue == [] && !combat:
		idle = false
	if verbose:
		print("task dropped")
	working = false
	current_task = null
	return oldtask
	
func check_for_task():
	pass

#************
#Inventory Functions
#************

func find_and_equip(base):
	var item = map.find_item_amount_for(base, 1, self)
	if item == null:
		return null
	order_equip(item)
	return item
	
func order_equip(item):
	#item.reserved_count += 1
	if item.location.entity() == "UNIT":
		return null
	var equiptask = EquipTask.new("self", item.location.position, "equip", item.location, item)
	equiptask.resource = {"item": item, "count": 1, "base": item.base}
	equiptask.fetchtarget = item.location
	queue.append(equiptask)
	return equiptask
	
func find_and_store(base, shelf, count):
	var item = await map.find_item_amount_for(base, count, self)
	
	if item == null:
		return null
	
	order_take(item, shelf, count)
	
	return item
	
func order_take(item, shelf, count):
	if item.location.entity() == "UNIT":
		return null
	#item.reserved_count += count
	var taketask = TakeTask.new("self", item.location.position, "take", item.location, item, shelf)
	taketask.count = count
	taketask.resource = {"item": item, "count": count, "base": item.base}
	taketask.fetchtarget = item.location
	queue.append(taketask)
	return taketask

func take(stack, shelf = "storage"):
	if stack == null:
		return false
	shelves[shelf].store(stack)
	stack.location = self
	return true

func has_item(base, count):
	var has = 0
	for key in shelves:
		var shelf = shelves[key]
		has += shelf.has(base, count)
	if has >= count:
		return true
	else:
		return false





func start_patrol(route):
	var bestdist = 100000000
	var best: Waypoint
	route.has += 1
	for node in route.nodes:
		var distance = global_position.distance_squared_to(node.global_position)
		if distance < bestdist:
			bestdist = distance
			best = node
	var task = PatrolTask.new(best, route, 0)
	task.fragile = true
	task.speed = "walk"
	queue.append(task)

func stop_patrol():
	if current_task is PatrolTask:
		current_task.patrol.has -= 1

func begin_idle():
	var found = true
	if map.zones.size() > 0:
		if map.zones.has("idle"):
			var zone = map.zones.idle.values()[0]
			var wandertarget = zone.get_random_square()
			if wandertarget != null:
				var movetask = MoveTask.new(wandertarget, wandertarget.global_position)
				movetask.fragile = true
				movetask.speed = "walk"
				movetask.personal = true
				queue.append(movetask)
		else:
			found = false
	else:
		found = false
	if !found:
		var possible = await get_accessible_tiles()
		if possible != {}:
			var rand = randi() % possible.size()
			var key = possible.keys()[rand]
			var square = possible[key]
			var movetask = MoveTask.new(square, square.global_position)
			movetask.fragile = true
			movetask.speed = "walk"
			movetask.personal = true
			queue.append(movetask)

func start_idle():
	idle = true
	map.taskmaster.idle_units.merge({id: self}, true)

func wander_sequence(delta):
	if wandertimer <= 0:
		begin_idle()
		wandertimer = randf_range(0, 5)
	else:
		wandertimer -= delta



#************
#Physics Process
#************

func consider_squads():
	var joining = []
	var leaving = []
	for key in rules.squads:
		var squad = rules.squads[key]
		var eligible = squad.check_eligibility(self)
		if eligible == 0:
			joining.append(squad)
		elif eligible == 3:
			leaving.append(squad)
	for squad in leaving:
		leave_squad(squad)
	for squad in joining:
		join_squad(squad)

func join_squad(squad):
	squads.merge({
		squad.id: squad
	}, true)
	squad.add_unit(self)
	
func leave_squad(squad):
	if squads.has(squad.id):
		squads.erase(squad.id)
	squad.remove_unit(self)

func face_target():
	if current_target != null:
		var relative_pos = current_target.position - position
		if relative_pos.x < 0:
			appearanceholder.scale.x = -1
			#scale.y = -1
		else:
			appearanceholder.scale.x = 1
	else:
		appearanceholder.scale.x = 1
		#scale.y = 1

func _physics_process(delta):
	#thread.start(think.bind(delta))
	think(delta)
	pass
	
func think(delta):
	if is_node_ready():
		var start = Time.get_ticks_usec()
		if map.active:
			if moving:
				nav.avoidance_priority = 0.5
				collision_priority = 0.5
				sleeping = false
			else:
				nav.avoidance_priority = 1
				collision_priority = 1
				sleeping = true
			if current_target != null:
				if !current_target.targetable:
					change_target(null)
			if current_task is KillTask:
				if !current_task.object.targetable:
					halt()
					update_task(null)
			if !transporting:
				if(!spawned):
					if spawnframes == 0:
						spawn()
					else:
						spawnframes = spawnframes - 1
				elif(!dead):
					
					face_target()
					#if movement_path == null || movement_path.path == []:
						#navigation_finished = true
					
					if asleep:
						aggression_active = false
					else:
						aggression_active = true
					
					overtime_effects(delta)
					
					tick_drain(delta)
					
					for buff in buffs:
						buff.time -= delta
						if buff.time <= 0:
							expire_buff(buff)
					if verbose:
						print(id)
						print(seen)
						
					if(stats.fuels != {}):
						healthbar.max_value = stats.fuels.get("health").max
						energybar.max_value = stats.fuels.get("energy").max
						healthbar.value = stats.fuels.get("health").value
						energybar.value = stats.fuels.get("energy").value
					if(current_task != null):
						if(current_task.job != null):
							prog.value = current_task.job.time
							
							
					if shelves.storage.contents != {}:
						pass
							
					
							
					#Need Logic	
					
					needs = get_needs()
					
					if !needs.is_empty():
						pass
					
					if stats.fuels.energy.value <= 0 && !asleep:
						pass_out()
						pass
						
					if stats.fuels.food.value <= 0:
						starve(delta)
						
					if slacking:
						slack_timer -= delta
						
					if slack_timer <= 0 && slacking:
						slacking = false
						
					if stats.fuels.loyalty.value <= 0 && !defecting && !slacking:
						if loyalty_timer <= 0:
							consider_loyalty()
						else:
							loyalty_timer -= delta
						
						#defect()
						
					if stats.fuels.health.value <= 0:
						die()
					
					var damaged = check_damage()
					if damaged != "" && !rnr && !combat && !slacking:
						if await rest_and_recuperation(damaged):
							pass
					var soft_damaged = check_soft_damage()
					if soft_damaged != "" && !rnr && !combat && !slacking && idle:
						if await rest_and_recuperation(soft_damaged):
							pass
						
					if !stored:
						
						
						pass
						await check_class()
						#await consider_squads()
						if queue == [] && current_task == null && !idle && !combat && !tired && !rnr:
							start_idle()
							
						for key in job_instances:
							var job = job_instances[key]
							if !job.task_exists && !job.waiting_for_resource:
								job.make_task_for_unit(self)
							elif job.waiting_for_resource:
								if job.check_needs().is_empty():
										job.make_task_for_unit(self)
						if (idle || slacking) && current_task == null && encounter == null && current_target == null && target_furniture == null && !rules.debugvars.standstill:
							wander_sequence(delta)
						
						if verbose:
							pass
						
						if(current_task != null):
							idle = false
							if current_task.doable():
								if(current_task.type == "tilechanges"):
									working = true
								elif current_task.type == "destroy":
									break_target(current_task.object)
								elif current_task.type == "kill":
									if current_task.object.targetable:
										change_target(current_task.object)
									update_task(null)
								elif current_task.type == "move" || current_task.type == "wander":
									if nav.is_navigation_finished():
										current_task.square.reserved = false
										working = false
										current_task = null
										halt()
								elif current_task.type == "idle":
									wandertimer -= delta
									if wandertimer <= 0:
										wandertimer = randf_range(0, 2)
										working = false
										var next_task = current_task.next_patrol()
										if next_task != null:
											update_task(next_task)
								elif current_task.type == "transport":
									working = false
									var task = current_task
									current_task = null
									await task.transport.store_unit(self)
								elif current_task.type == "interact" || current_task.type == "consume" || current_task.type == "service":
									working = true
								elif current_task.type == "build":
									working = true
								elif current_task.type == "learn":
									working = true
								elif current_task.type == "restore":
									working = true
								#Both of these happen instantly
								elif current_task.type == "startescort":
									start_escorting(current_task.client)
									update_task(current_task.next_action)
								#Unit is dropped, then it starts the job
								elif current_task.type == "escort":
									current_task.client.global_position = global_position
									current_task.job.finish_escort(current_task.client)
									
									update_task(null)
									#var done = true
									#for key in filling:
									#	var stat = filling[key]
									#	if stat.value < stat.filltarget:
									#		done = false
									#if done:
									#	current_task.job.complete()
										#finish_task()
									#	pass
								elif current_task.type == "fetch":
									var item = current_task.grab_item()
									if take(item):
										future_weight -= current_task.count
										storing = true
										if verbose:
											print("Grabbed:")
											#print(item.resource)
										current_task.done = true
										update_task(current_task.next_action)
									else:
										delete_task()
								elif current_task.type == "equip":
									var item = current_task.item
									if pickup_and_equip(item):
										future_weight -= current_task.count
									current_task = null
								elif current_task.type == "take":
									if take(current_task.grab_item(), current_task.shelf):
										future_weight -= current_task.count
										current_task = null
								elif current_task.type == "haul":
									if take(current_task.grab_item()):
										future_weight -= current_task.count
										storing = true
										if verbose:
											print("Grabbed:")
											print(item.resource)
										update_task(current_task.next_action)
									else:
										pass
								elif current_task.type == "cast":
									var has_focus = current_task.action.has_focus()
									#var in_range = current_task.action.in_range(current_task.get_movement())
									if has_focus:
										if current_task.object != null:
											fire_action(current_task.action, current_task.object)
										else:
											fire_action_ground(current_task.action, current_task.target)
									elif in_range:
										if queued_actions == []:
											queued_actions.append(current_task.action)
									else:
										print("Cast failed!")
										#current_task.action.fire_at(current_task.object)
									#elif queued_actions == []:
										#queued_actions.append(current_task.action)
									update_task(null)
									halt()
								elif current_task.type == "delivery":
									storing = false
									if verbose:
										print("delivering:")
										#print(item.resource)
									await current_task.object.store(shelves.storage.split(current_task.base, current_task.count), current_task.haulshelf, current_task.haulfinal)
									working = false
									current_task = null
								elif current_task.type == "store":
									storing = false
									if verbose:
										print("delivering:")
										#print(item.resource)
									await current_task.object.store(shelves.storage.split(current_task.base, current_task.count), "storage", current_task.haulshelf, current_task.haulfinal)
									working = false
									current_task = null
								elif current_task is PatrolTask:
									if navigation_finished:
										working = false
										var next_task = current_task.next_patrol()
										if next_task != null:
											update_task(next_task)
							else:
								if nav.is_navigation_finished() && current_target == null && (target_furniture == null || target_furniture.dead):
									working = false
									var reserving = true
									if current_task is GrabTask:
										reserving = false
									if current_interactzone != null:
										current_interactzone.in_use = false
									if  movement_path == null || movement_path.path == []:
										#var square = current_task.get_square(self, reserving, current_task.jobslot)
										var movepos = current_task.get_movement()
										if movepos != null:
											set_movement_target(movepos)
										else:
											pass
						
						
						
						# **************************
						# *******COMBAT LOGIC*******
						# **************************
							
						if current_task != null && current_task is DestroyTask && current_task.object.dead:
							finish_task()
							target_furniture = null
						
						if !combat && encounter != null:
							if map == encounter.map:
								if encounter.objective != null:
									if !encounter.objective.dead:
										if current_task == null && target_furniture == null && !combat:
											if encounter.team_goals[allegiance] != "spy":
												var task = encounter.get_objective_task(self)
												if task != null:
													task.personal = true
													update_task(task)
												else:
													start_exfil()
											else:
												if done_invading():
													start_exfil()
												elif find_spy_target() == null:
													start_exfil()
								elif encounter.team_goals[encounter_role] == "killall":# && encounter.finished():
									var task = encounter.get_objective_task(self)
									if task != null:
										update_task(task)
								elif encounter.team_goals[encounter_role] == "defend":
									pass
								else:
									if current_task != null && current_task is DestroyTask && current_task.object.dead:
										delete_task()
										target_furniture = null
									if current_task == null:
										start_exfil()
						
						if(combat && current_target == null):
							if verbose:
								print("COMBATRESULT: Stuck after combat!")
								
						if queue != [] && current_task != null && current_task.fragile:
							drop_task()
								
						if(!working && active && !rallied && current_task == null):
							if(movement.size() != 0):
								#if verbose:
								print("grabbing from personal movement queue")
								#If a new task is grabbed as a queue, set it's target position as the current position
								var newtask = movement.pop_front()
								update_task(newtask)
							elif(queue.size() != 0):
								if !combat || queue[0].during_combat:
									
									#if verbose:
									print("grabbing from personal queue")
									#If a new task is grabbed as a queue, set it's target position as the current position
									var newtask = queue.pop_front()
									if newtask.job != null:
										prog.max_value = newtask.job.speed
										prog.value = newtask.job.time
									update_task(newtask)
								#think_about_fulfilment()
						
						for key in abilities:
							var ability = abilities[key]
							if ability.base.toggling:
								ability.base.check_toggle(ability)
						
						for key in active_abilities:
							var ability = active_abilities[key]
							if ability.base.check_conditions(self):
								if !ability.base.everyframe:
									if ability.time <= 0:
										if ability.autocast || ability.base.automatic:
											ability.base.fire(ability)
									else:
										ability.think(delta)
								else:
									ability.base.fire(ability, delta)
						
						#move(delta)
						
						if current_task != null:
							if current_task.job != null:
								if current_task.job.done:
									finish_task()
						if(working):
							var work_amount = delta
							work_amount += (work_amount * (mods.ret("haste") / 100))
							#var finished = current_task.progress(work_amount)
							if current_task.job != null:
								prog.visible = true
								prog.value = current_task.job.time
							#if(finished):
								#if job_instances.has(current_task.job.id):
									#end_personal_job(current_task.job)
								#current_task = null
								#working = false
								#prog.visible = false
						move(delta)
						var end = Time.get_ticks_usec()
						var time = (end-start)/1000000.0
						print("time to calc unit " + id + ": %s" % [time])
					else:
						if stored_in != null:
							global_position = stored_in.global_position
			else:
				pass
				
			

func attract(target):
	var roll = randi() % 100
	if roll > 50:
		target.be_attracted(self)
	drop_task()
	halt()

	
#Non-Aligned are held in place for a few moments for this. Allies will converse instantly and keep doing what they were doing.
#After this, unit should be "immune" to further conversations from the same allegiance temporarily. Use timers for this.
#Only player units and Agitators will try to converse.
func converse(with):
	talktimer = 5.0
	if with.allegiance == allegiance:
		var heal = randi() % stats.qualities.charisma.value
		with.change_stat("loyalty", heal)
	else:
		var damage = (randi() % stats.qualities.guile.value) * -1
		damage += 5
		with.change_stat("loyalty", damage)
	
#Unit should try conversing with Enemies (not Hostiles) first
func try_conversation(delta):
	if talktimer <= 0:
		if !seen.is_empty():
			if !enemies.is_empty():
				find_conversation(enemies)
			else:
				find_conversation(seen)
	else:
		talktimer -= delta

#Conversation target is randomized
func find_conversation(targets):
	var i = randi() % targets.keys().size()
	var target = targets[targets.keys()[i]]
	converse(target)

func be_dropped():
	stored = false
	stored_in = null

func start_escorting(actor):
	actor.animplayer.play("laydown")
	unitshelf.store_unit(actor)
	actor.stored = true

#ACCEPTS HASTE/SPEED MODIFIERS
func work_value(delta, wantedmodifiers = {}):
	var result = 0
	for key in wantedmodifiers:
		var modifyamount = wantedmodifiers[key]
		var modpercent = modifyamount / 100
		var modifier = mods.ret(key)
		modifier *= modpercent
		var totalpercent = modifier / 100
		modifier = delta * totalpercent
		result += modifier
	return result
			
	
func finish_task():
	if current_task != null:
		if current_task.job != null:
			if job_instances.has(current_task.job.id):
				end_personal_job(current_task.job)
		current_task.remove_actor(self)
		if current_task.job != null:
			if current_task.job.location is Furniture:
				current_task.job.location.in_use = false
		delete_task(true)
	animplayer.play("RESET")
	current_task = null
	clear_interact()
	working = false
	prog.visible = false

func clear_interact():
	if current_interactzone != null:
		current_interactzone.in_use = false
		current_interactzone.actor = null

func set_equipment(slot, base):
	equip_overrides[slot] = base

func spy_on(target):
	heat += target.spyheat
	spied_on.merge({
		target.id: target
	})

func find_spy_target():
	var object = map.find_spy_target(self)
	if object != null:
		var job = object.start_job(object.spyjob, true)
		var task = job.return_task()
		task.reserving = false
		update_task(task)
		return object
	else:
		return null

func done_invading():
	if encounter != null:
		if encounter.bravery <= 0:
			return true
		if encounter.team_goals[allegiance] == "spy":
			if heat >= 30:
				return true
	return false

func start_exfil():
	if map.active_port != null:
		var exfiljob = map.active_port.make_exfil()
		map.active_jobs.merge({
			exfiljob.id: exfiljob
		})
		exfiljob.started = true
		var task = exfiljob.return_task()
		task.stoppable = false
		task.reserving = false
		update_task(task)
	else:
		die()

func exfiltrate():
	if faction != null:
		faction.heat += heat
	if defecting && allegiance != "player":
		rules.new_free_agent(self)
	leave()


func leave_storage():
	if stored_in != null:
		global_position = stored_in.get_square(self)
		stored_in = null
	imprisoned = false
	asleep = false

func order_capture():
	if !captured:
		captured = true
		var furniture = await suitable_prison()
		if furniture != null:
			var job = furniture.start_job(furniture.primary_job, true)
			if job != null:
				job.make_escort_for_unit(self)
	
func order_rescue():
	if !rescued:
		rescued = true
		var furniture = await suitable_rest("energy")
		if furniture != null:
			var job = furniture.start_job(furniture.primary_job, true)
			if job != null:
				job.make_escort_for_unit(self)
				#job.make_task_for_unit(self)

func pass_out():
	toggle_self_aggression(false)
	animplayer.play("laydown")
	drop_task()
	filling.merge({
		"energy": stats.fuels["energy"]
	})
	asleep = true
	rnr = true
	start_personal_job("passout")
	if allegiance == "player":
		order_rescue()
	else:
		capturable = true
		die()
		#order_capture()
	
func starve(delta):
	for key in starvation_drains:
		var amount = starvation_drains[key] * delta * -1
		change_stat(key, amount)
		
func consider_loyalty():
	var roll = loyalty_roll()
	if roll == 0:
		slacking = false
		loyalty_timer = float(randi() % 10)
	elif roll == 1:
		slack_off()
		loyalty_timer = float(randi() % 30)
	elif roll == 2:
		defect()
		slacking = false
		
func slack_off():
	slacking = true
		
#0 = Unit is loyal
#1 = Unit decides to slack off
#2 = Unit decides to immediately defect
#3 = Unit decides to rebel
func loyalty_roll():
	if combat:
		var defectchance = mods.ret("defectchance")
		var breakchance = mods.ret("breakchance") + defectchance
	else:
		var defectchance = mods.ret("defectchance")
		var slackchance = mods.ret("slackchance") + defectchance
		var rebelchance = mods.ret("rebelchance")
		var roll = randi() % 100
		if roll < defectchance:
			return 2
		elif roll < slackchance:
			return 1
	return 0
		
func defect():
	toggle_self_aggression(false)
	drop_task()
	defecting = true
	start_exfil()

func leave():
	if rules.selected.has(id):
		rules.selected.erase(id)
		rules.interface.update_selection()
	if encounter != null:
		encounter.units.erase(id)
	map.destroy_unit(self)
	#dead = true
	if quadtree != null:
		quadtree.remove(self)
	if current_task != null:
		drop_task()
	set_process(false)
	if verbose:
		print(nickname + id + "Unit Exfiltrated")
	visible = false
	#if(decay <= 0):
	map.remove_unit(self)
	if(rules.selected != null):
		if(rules.selected.has(id)):
			rules.selected.erase(id)
		#queue_free()
	return true

func be_targeted(by):
	targeted_by.merge({
		by.id: by
	})
	
func be_untargeted(by):
	targeted_by.erase(by.id)
	#by.untarget(self)

func die(killer = null):
	drop_storage()
	targetable = false
	for key in targeted_by:
		var unit = targeted_by[key]
		be_untargeted(unit)
	if rules.selected.has(id):
		rules.selected.erase(id)
		rules.interface.update_selection()
	if master:
		rules.master_death(self)
	if encounter != null:
		encounter.units.erase(id)
	map.destroy_unit(self)
	dead = true
	if quadtree != null:
		quadtree.remove(self)
	if current_task != null:
		drop_task()
	if killer != null:
		killer.spread_experience_around(experience_reward, killer.allegiance)
	set_process(false)
	if verbose:
		print(nickname + id + "COMBATRESULT: Unit killed")
	visible = false
	#if(decay <= 0):
	map.remove_unit(self)
	rules.world_units.erase(id)
	if(rules.selected != null):
		if(rules.selected.has(id)):
			rules.selected.erase(id)
		#queue_free()
	return true

func spread_experience_around(amount, allegiance):
	var learners = []
	for key in in_sight:
		var unit = in_sight[key]
		if unit.allegiance == allegiance:
			learners.append(unit)
	var split = learners.size()
	split += 1
	var learn_amount = amount / split
	gain_experience("", learn_amount)
	for unit in learners:
		unit.gain_experience("", learn_amount)

func has_los(point):
	tspotter.target_position = point - position
	tspotter.force_raycast_update()
	var collider = tspotter.get_collider()
	var collide = tspotter.is_colliding()
	return !tspotter.is_colliding()

func queue_transit(newmap, transport):
	if on_map:
		var furn = map.active_port
		var task = TransportTask.new(furn, transport)
		drop_queue()
		update_task(task)
	else:
		transport.store_unit(self)
	#queue.push_back(task)

func drop_queue():
	for i in range(queue.size()-1,-1,-1):
		var task = queue[i]
		if !task.personal:
			map.taskmaster.add_task(task)
		queue.pop_at(i)

func teleport_to_map_entry(newmap):
	rules.transfer_unit(self, newmap)
	pass
	
func teleport_to_point(point):
	global_position = point

func entity():
	return "UNIT"

func _on_navigate(pos):
	set_movement_target(pos)

func targeted(targeterid):
	if verbose:
		print("targeted by " + targeterid)

func hide_from_everyone():
	var to_remove = []
	for key in in_sight_of:
		var unit = in_sight_of[key]
		if unit != null:
			if unit.allegiance != allegiance:
				if hide_from(unit):
					pass
	for key in to_remove:
		in_sight_of.erase(key)

func hide_from(unit):
	var rand = randi() % 100
	if rand > 50:
		leave_stealth()
		return true
	else:
		return false

func enter_stealth():
	stealthed = true
	stealthind.visible = true

func leave_stealth():
	stealthed = false
	stealthind.visible = false
	for key in in_sight_of:
		var unit = in_sight_of[key]
		unit.see(self)

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
		add_relation(body)
		add_enemy(body)
		body.seen_by.merge({id: self})
	elif body.entity() == "FURNITURE":
		seen_furniture.merge({
			body.id: body
		}, true)
	
func add_relation(unit):
	var relation = ""
	if faction != null:
		relation = faction.get_relation(unit.faction)
	else:
		relation = "neutral"
	relations.merge({
		relation: {}
	})
	relations[relation].merge({
		unit.id: unit
	})
		
func remove_relation(unit):
	var relation = ""
	if faction != null:
		relation = faction.get_relation(unit.faction)
	else:
		relation = "neutral"
	if relations.has(relation):
		relations[relation].erase(unit.id)
	
func add_enemy(body):
	var relation = ""
	if faction != null:
		relation = faction.get_relation(body.faction)
	else:
		relation = "neutral"
	if relation == "enemy" || relation == "neutral":
		if body.aggression_active:
			if body.aggressive:
				hostiles.merge({body.id: body})
			else:
				enemies.merge({body.id: body})
		else:
			neutralized.merge({body.id: body})
	
	
func leave_sight(body):
	if body.entity() == "UNIT":
		in_sight.erase(body.id)
	elif body.entity() == "FURNITURE":
		seen_furniture.erase(body.id)
	
func unsee(body):
	if body.entity() == "UNIT":
		in_sight.erase(body.id)
		body.in_sight_of.erase(id)
		if(current_target != null):
			if(current_target.id == body.id):
				change_target(null)
		if(seen.has(body.id)):
			seen.erase(body.id)
		if(enemies.has(body.id)):
			enemies.erase(body.id)
		if(hostiles.has(body.id)):
			hostiles.erase(body.id)
		if(body.seen_by.has(id)):
			body.seen_by.erase(id)
		remove_relation(body)
	elif body.entity() == "FURNITURE":
		seen_furniture.erase(body.id)

func transport():
	stored = true
	global_position = Vector2(-100000000, -100000000)

#func _on_vision_body_entered(body):
#	if(body.id != id):
#		if(body.entity() == "UNIT"):
#			see(body)

#func _on_vision_body_exited(body):
#	if(body.id != id):
#		if(body.entity() == "UNIT"):
#			unsee(body)
			



func _on_selection_box_mouse_entered():
	await rules.hover(self) # Replace with function body.


func _on_selection_box_mouse_exited():
	if rules.hovered != null:
		if rules.hovered.id == id:
			await rules.hover(null)


func _on_velocity_computed(safe_velocity: Vector2):
	global_position = global_position.move_toward(global_position + safe_velocity, movement_delta)
	



func _on_vision_cone_body_entered(area):
	if area is Furniture:
		pass
	if(area.id != id):
		enter_sight(area)


func _on_vision_cone_body_exited(area):
	if(area.id != id):
		unsee(area)





func save():
	var saved_queue = []
	var saved_equipment = {}
	var saved_lessons = []
	var saved_inventory = []
	var saved_stats = {}
	for statname in stats.fuels:
		var saved_stat = stats.fuels[statname].save()
		saved_stats.merge({
			statname: saved_stat
		})
	for task in queue:
		saved_queue.append(task.save())
	for slot in equipment:
		saved_equipment.merge({
			
		})
	var save_dict = {
		"filename" : get_scene_file_path(),
		"id": id,
		"datakey": datakey,
		"firstname": firstname,
		"lastname": lastname,
		"nickname": nickname,
		"position": {"x": global_position.x, "y": global_position.y},
		"map": map.id,
		"stats": saved_stats,
		"lessons": [],
		"equipment": saved_equipment,
		"shelves": [],
		"queue": saved_queue
	}
	if current_task != null:
		save_dict.merge({
			"current_task": current_task.save(),
		})
	return save_dict

func load_save(gamedata, savedata):
	id = savedata.id
	datakey = savedata.datakey
	if data.units.has(datakey):
		load_data(rules, gamedata, data.units[datakey])
	else:
		load_data(rules, gamedata, data.default_class)
	if rules.ids.has(savedata.map):
		map = rules.ids[savedata.map]
	for statname in savedata.stats:
		var stat = Fuel.new({"name": "", "num": 0, "category": "", "newtarget": 0})
		stat.copy(rules.data.fuels.get(statname))
		stat.load_save(savedata.stats[statname])
		stats.fuels.merge(
			{statname: stat} 
		)
	firstname = savedata.firstname
	lastname = savedata.lastname
	nickname = savedata.nickname
	global_position = Vector2(savedata.position.x, savedata.position.y)
	if savedata.has("current_task"):
		var taskdata = savedata.current_task
		var task = load_task(taskdata)
		if task != null:
			update_task(task)
	for taskdata in savedata.queue:
		var task = load_task(taskdata)
		if task != null:
			queue.append(task)
	for lessondata in savedata.lessons:
		if data.lesson.has(lessondata.base):
			var base = data.lesson[lessondata.base]
			var lesson = start_lesson(base)
			lesson.load_save(lessondata)
	for slotdata in savedata.equipment:
		pass

func load_task(taskdata):
	if taskdata.type == "interact":
		#Make a new task, then assign Job and Object to it
		var task = Task.new(taskdata.desired_role, Vector2(taskdata.target.x, taskdata.target.y), null, taskdata.type, null)
		var success = true
		if rules.ids.has(taskdata.job):
			task.job = rules.ids[taskdata.job]
		else:
			success = false
		if rules.ids.has(taskdata.object):
			task.object = rules.ids[taskdata.object]
		else:
			success = false
		if success:
			return task
		else:
			return null
	elif taskdata.type == "move":
		#Just make a new movetask pointing to the same square
		var square = map.blocks[taskdata.targetsquare.x][taskdata.targetsquare.y]
		var task = MoveTask.new(square, square.global_position)
		return task
	elif taskdata.type == "haul" || taskdata.type == "store":
		#Make new task, then assign Stack and Object. If it's a haul, assign the Store task as well
		var task = GrabTask.new(taskdata.desired_role, Vector2(taskdata.target.x, taskdata.target.y), taskdata.type, null, null, taskdata.count)
		if rules.ids.has(taskdata.item):
			task.item = rules.ids[taskdata.item]
		if rules.ids.has(taskdata.object):
			task.object = rules.ids[taskdata.object]
		return task
	elif taskdata.type == "patrol":
		#Make new task pointing to patrol, as well as the current patrol index
		
		var patrol: Patrol
		var waypoint: Waypoint
		if rules.ids.has(taskdata.patrol):
			patrol = rules.ids[taskdata.patrol]
		if rules.ids.has(taskdata.waypoint):
			waypoint = rules.ids[taskdata.waypoint]
		var task = PatrolTask.new(waypoint, patrol, taskdata.index)
		return task

func get_repair_value(target, delta):
	var result = fixrate * delta
	var hastemod = result * (mods.ret("haste") / 100)
	result += hastemod
	return result

func add_clearance(clearance):
	if clearances.has(clearance):
		clearances.merge({
			clearance: clearances[clearance] + 1
		}, true)
	else:
		clearances.merge({
			clearance: 1
		})
		#navigation_agent.set_navigation_layer_value(clearance, true)
	
func increase_augmentcap(type):
	if cultivation.has(type):
		cultivation += 1
	else:
		cultivation.merge({
			type: 1
		})
	calc_upgradelimits()
	
func gain_experience(type, amount):
	var total = amount
	experience += total
	if experience >= needed_experience:
		level_up()
	
func stat_potential_modifier(stat):
	for key in stats:
		if stats[key].has(stat):
			var diff = potential[stat] - stats[key][stat].value
			var mod = diff / potential[stat]
			return mod
	
func gain_stat_experience(stat, amount):
	var total = amount
	if potential.has(stat):
		var mod = stat_potential_modifier(stat)
		var bonus = total * mod
		total += bonus
	statexp[stat] += total
	if statexp[stat] >= statexp_needed[stat]:
		stat_level_up(stat)
	
func stat_level_up(stat):
	var newexp = 0
	if statexp[stat] >= statexp_needed[stat]:
		newexp = statexp[stat] - statexp_needed[stat]
	statexp[stat] = newexp
	for key in stats:
		if stats[key].has(stat):
			stats[key][stat].modify(1)
	
func level_up():
	cultivation.lesson += 1
	level += 1
	lesson_picks += 1
	calc_upgradelimits()
	calc_scaling()
	var leftover = 0
	if experience >= needed_experience:
		leftover = experience - needed_experience
	experience = leftover
	needed_experience = (scaling * 100) + 900
	
func calc_scaling():
	scaling = 0.0
	scaling += (cultivation.lesson * 1.0)
	scaling += (cultivation.science * 1.0)
	
func calc_upgradelimits():
	lessonmax = level * 4
	for key in cultivation:
		var value = cultivation[key]
		auglimits.merge({
			key: value
		}, true)
	
func remove_clearance(clearance):
	if clearances.has(clearance):
		var result = clearances[clearance] - 1
		if result <= 0:
			clearances.erase(clearance)
			#navigation_agent.set_navigation_layer_value(clearance, false)
		else:
			clearances.merge({
				clearance: result
			}, true)
			pass
	#navigation_agent.set_navigation_layer_value(clearance, false)
	
func add_order(order):
	orders.append(order)
	var result = order.return_join_effects()
	callv(result.effect, result.args)
	
func remove_order(order):
	orders.pop_at(orders.find(order))
	var result = order.return_leave_effects()
	callv(result.effect, result.args)

func object_name(length = "full"):
	var result = ""
	if length == "full":
		result = firstname + " \"" + nickname + "\" " + lastname
	if length == "nickname":
		result = "\"" + nickname + "\""
	if length == "short":
		if nickname != "":
			return nickname
		else:
			return lastname
	return result

func status():
	if current_task != null:
		return "performing a task"
	if current_target != null:
		return "attacking " + current_target.object_name("short")
	return "doing nothing in particular"

func name():
	return object_name()

func roll(stats):
	return randi() % 100


func _on_interaction_circle_body_entered(area) -> void:
	if area.id != id:
		can_interact.merge({area.id: area}, true)
	



func _on_interaction_circle_body_exited(area) -> void:
	if area.id != id:
		can_interact.erase(area.id)
		
func get_modifier(mod):
	var result = 0
	if modifiers.has(mod):
		result = modifiers[mod]
	return result
	
func tick_drain(delta):
	var val = sustain_actions(delta)
	#stats.fuels.attention.spend(val)
	for key in stats.fuels:
		var fuel = stats.fuels[key]
		if key == "attention":
			pass
		var val2 = fuel.regenerate(delta)
		pass
	
	#apply_drain(rules.base_drain, delta)
	

func calc_shield(delta):
	var cap = mods.ret("shieldmax")
	var chargerate = mods.ret("shieldcharge")
	if cap > 0:
		var amount = chargerate * delta
		if shield < cap:
			shield += amount
		if shield > cap:
			shield = cap


func check_melee():
	in_melee = melee_range.size() > 0
	return in_melee

func _on_melee_radius_body_entered(area) -> void:
	if area.id != id:
		if area.allegiance != allegiance:
			area.in_melee = true
			area.melee_range.merge({
				id: self
			})

func _on_melee_radius_body_exited(area) -> void:
	if area.id != id:
		area.melee_range.erase(id)
		area.check_melee()






func _on_hearing_radius_body_entered(body: Node2D) -> void:
	if body.id != id:
		body.heard.merge({
			id: self
		})
		can_hear.merge({
			body.id: body
		})
	


func _on_hearing_radius_body_exited(body: Node2D) -> void:
	if body.id != id:
		can_hear.erase(body.id)
		body.heard.erase(id)
