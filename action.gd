extends Object
class_name Action

var data
var rules

var impacts = []

var tooltipdata

var autocast = false

#Play these when the unit performs action
var visuals = []

#Chance to pop up these sound bubbles when performing this action
var bubbles = []

#Unit does this when performing this action
var animation = ""

var unit

#Defaults to 0.5 if the data has no focus cost
var energy_cost = 0.5

#set false to make action free to click
#used for things like sustained powers
var spend_on_cast = true

var range = 0

var cooldown = 1.0
var time = 0.0

var controlled = false
var behavior

var cast_time = 1.0

var cast_timer = 0.0
var casting = false

var last_fire_position

#mods that influence Rate
var ratemods = {}

#whether this action wants a unit to move when casting, or always cast from one place
var move_to = true

#tags for the action
var tags = []


var key = ""

#the Consumable used as "ammo" for the action
var ammo
#the amount of Consumable used as ammo
var ammo_used = 0

var tooltip_description = "This is some sort of action"

var autoable = true

var plannable = true
var planned = false
var plan_target

func fire_at(target, delta = 0.0):
	time = 0
	spend_ammo()
	
func spend_ammo():
	if unit != null:
		if ammo != null:
			unit.spend_ammo(ammo, ammo_used)

func cast(delta, target):
	pass

func _init(gamedata, actiondata, parent = null):
	data = gamedata
	rules = data.rules
	unit = parent
	if actiondata.has("conditions"):
		behavior = ActionBehavior.new(rules, unit, self, actiondata.conditions)
		controlled = true
	if actiondata.has("impacts"):
		for impdata in actiondata.impacts:
			var newimp = rules.make_impact(impdata, parent)
			#var newimp = DamageImpact.new(impdata, parent)
			impacts.append(newimp)
	if actiondata.has("visuals"):
		for visdata in actiondata.visuals:
			if gamedata.visual_effects.has(visdata.name):
				var anim = gamedata.visual_effects[visdata.name]
				visdata.merge({
					"visual": anim
				})
				var vis = ActionVisual.new(visdata)
				visuals.append(vis)
	if actiondata.has("autoable"):
		autoable = actiondata.autoable
	if actiondata.has("plannable"):
		plannable = actiondata.plannable
	if actiondata.has("animation"):
		animation = actiondata.animation
	if actiondata.has("key"):
		key = actiondata.key
	if actiondata.has("cooldown"):
		cooldown = actiondata.cooldown
	if actiondata.has("ammo"):
		ammo = gamedata.items[actiondata.ammo]
	if actiondata.has("ammo_cost"):
		ammo_used = actiondata.ammo_cost
	time = cooldown
	if actiondata.has("energy_cost"):
		energy_cost = actiondata.energy_cost
	if actiondata.has("bubbles"):
		for bubbledata in actiondata.bubbles:
			var bubble = SoundBubbleData.new(bubbledata)
			bubbles.append(bubble)

func make_plan():
	var power = PlanPower.new({
		"name": key,
		"on_cast": "fire_attack_at_target",
		"cast_args": [],
		"category": "unit",
		"action": self
	}, rules)
	power.make_tool()
	return power

func cool_down(delta):
	if time < cooldown:
		time += delta
		return false
	if time > cooldown:
		time = cooldown
		return true
	return true

func can_fire(target):
	var energy = has_energy()
	var ammo_valid = has_ammo()
	var range = in_range(target.global_position)
	return energy && range && ammo_valid

func has_ammo():
	if ammo == null || ammo_used == 0:
		return true
	else:
		var has = unit.has_ammo(ammo, ammo_used)
		return has

func has_energy():
	var has = unit.stats.fuels.energy.value >= energy_cost
	return has
	
func in_range(pos):
	var distance = unit.global_position.distance_squared_to(pos)
	return distance <= (range * range)

func make_power():
	pass

func make_tooltip():
	var tips = []
	var tipdata = {
		#"name": "Action Tooltip",
		"text": tooltip_description,
		"title": key,
		"tips": [
			{
				"type": "TextTip",
				"text": tooltip_description
			}
		]
	}
	#var tips = []
	var desc = ""
	for impact in impacts:
		#var text = String.num(impact.magnitude) + " mag. damage"
		var text = impact.get_text() + "\n"
		desc = desc.insert(0, text)
		#var tip = {"type": "TextTip",
			#"text": text,}
		#tips.append(tip)
	var tip = {"type": "TextTip",
			"text": desc,}
	tipdata.tips.append(tip)
	var tooltip = TooltipData.new(tipdata)
	return tooltip

func plan_for(target):
	if can_fire(target):
		plan_target = target
		planned = true
		return true
	return false
	
func planned_fire():
	fire_at(plan_target)

func check_fire(target):
	if behavior != null:
		if behavior.satisfied():
			fire(target)
			return true
	return false
#Extend this
func fire(target):
	pass
	#for impact in impacts:
		#impact.fire(target, crits)
