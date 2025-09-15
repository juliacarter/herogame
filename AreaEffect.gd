extends Node2D
class_name AreaEffect

@onready var rules = get_node("/root/WorldVariables")
@onready var data = get_node("/root/Data")

@onready var collision = get_node("CollisionShape2D")

@onready var los = get_node("LoSRay")

var started = false

var indicator

var caster
var exclude_caster = true

var area

var radius = 64

var width = 0

#the maximum distance the effect can be sent from the origin
var max_distance = 128
#
var distance = 0

#amount of time (if any) the effect stays alive until firing
var time = 0.0
var countdown = 0.0

var fired = false

#amount of time the effect takes to fade away after it fires
var fadetime = 0.5
var fadedown = 0.5

#whether or not the effect is anchored to a specific object
var anchored = false
var anchored_to

#origin is the "beginning" of the AoE
#position is the end
#for normal AoEs, position is all that matters
#for cones and lines, AoE is stretched between origin and position
var origin

#apply these payloads to targets
var payloads = []

var active = false

#AoE needs to stay active for one frame to allow bodies to be detected
#maybe come up with a better way to do this, but its not a big deal. feels pretty much instant already
var oneframe = false

var shape

var endpoint

#the point to use when determining where the attack comes from
var attack_pos

var col

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func load_aoe(aoedata, pos, newcaster = null, neworigin = null):
	caster = newcaster
	#global_position = pos
	if aoedata.has("shape"):
		indicator = rules.indicatorscenes[aoedata.shape].instantiate()
		indicator.parent = self
		add_child(indicator)
		indicator.load_aoe(aoedata)
	if aoedata.has("radius"):
		radius = aoedata.radius
		indicator.set_radius(radius)
	if aoedata.has("angle"):
		pass
	if aoedata.has("max_distance"):
		max_distance = aoedata.max_distance
	if aoedata.has("payloads"):
		for payloaddata in aoedata.payloads:
			var payload = Payload.new(rules, data, payloaddata, caster)
			payloads.append(payload)
	if origin != null:
		set_origin(neworigin)
	else:
		set_origin(pos)
	set_pos(pos)
	indicator.set_origin(to_local(origin))
	#indicator.update_position(pos)
	make_area()
	active = true
	top_level = true
	
func set_pos(new):
	position = new
	attack_pos = new
	los.global_position = new
	
	
func set_origin(new):
	origin = new

func make_area():
	var newarea = Area2D.new()
	var newcol = CollisionShape2D.new()
	col = newcol
	col.debug_color = Color.ROYAL_BLUE
	shape = make_circle()
	newcol.shape = shape
	area = newarea
	area.add_child(newcol)
	area.set_collision_mask_value(2, true)
	area.priority = 100
	add_child(area)
	
func make_circle():
	var newshape = CircleShape2D.new()
	newshape.radius = radius
	return newshape

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if started:
		await check_fire(delta)
	else:
		started = true
	
func check_fire(delta):
	if active && oneframe:
		if !fired:
			if countdown <= 0:
				fire()
	oneframe = true
	if fired:
		#indicator()
		fadedown -= delta
		check_fade()
	else:
		await fire()
	if fadedown <= 0:
		remove()
	#queue_redraw()
		
func check_fade():
	var opacity = fadedown / fadetime
	modulate = Color(1, 1, 1, opacity)

func remove():
	get_parent().remove_child(self)
	queue_free()

func activate():
	active = true

func check_los(target):
	los.target_position = to_local(target)
	los.force_raycast_update()
	return !los.is_colliding()

func fire():
	top_level = true
	
	var targets = area.get_overlapping_bodies()
	var areas = area.get_overlapping_areas()
	#indicator()
	for target in targets:
		if target != caster || !exclude_caster:
			fire_at(target)
	fired = true

func fire_at(target):
	for payload in payloads:
		if check_los(target.global_position):
			payload.fire_at(target, attack_pos)
