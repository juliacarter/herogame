extends Object
class_name JobData

var action
var args
var speed
var rules
var requirements = {}
var type
var on_start
var automatic
var service = false

var modifiers = {}

var continues

var jobname

var instant = false

var slots = {}

var key

var in_place = false

var personal = false

var desired_role = "worker"

var drains = {}
var skilltrains = {}

var experience = {}

var certs = {}

var healing = {}

var jobclass = "Job"

var baseclass = "JobBase"

var max_level = 0

func _init(data):
	if data.has("name"):
		jobname = data.name
	else:
		jobname = "placeholder"
	if data.has("class"):
		jobclass = data.class
	if data.has("max_level"):
		max_level = data.max_level
	if data.has("healing"):
		healing = data.healing.duplicate()
	if data.has("in_place"):
		in_place = data.in_place
	if data.has("experience"):
		experience = data.experience.duplicate()
	if data.has("instant"):
		instant = data.instant
	if data.has("certs"):
		certs = data.certs.duplicate()
	if data.has("skilltrains"):
		skilltrains = data.skilltrains.duplicate()
	if data.has("modifiers"):
		modifiers = data.modifiers.duplicate()
	if data.has("personal"):
		personal = data.personal
	if data.has("service"):
		service = data.service
	if data.has("continues"):
		continues = data.continues
	if data.has("baseclass"):
		baseclass = data.baseclass
	slots = data.slots
	action = data.action
	args = data.args
	speed = data.speed
	type = data.type
	if data.has("desired_role"):
		desired_role = data.desired_role
	if data.has("on_start"):
		on_start = data["on_start"]
	if data.has("automatic"):
		automatic = data["automatic"]
	if data.has("repeating"):
		automatic = data["repeating"]
	if data.has("drains"):
		drains = data.drains
	
func attach_rules(newrules):
	rules = newrules
