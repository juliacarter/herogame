extends Object
class_name Action

var autocast = false

#Play these when the unit performs action
var visuals = []

#Chance to pop up these sound bubbles when performing this action
var bubbles = []

#Unit does this when performing this action
var animation = ""

var unit

#Defaults to 0.5 if the data has no focus cost
var focus_cost = 0.5

#set false to make action free to click
#used for things like sustained powers
var spend_on_cast = true

var range = 0

var cooldown = 1.0
var time = 0

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

func cast(delta, target):
	pass

func _init(gamedata, actiondata, parent = null):
	unit = parent
	if actiondata.has("visuals"):
		for visdata in actiondata.visuals:
			if gamedata.visual_effects.has(visdata.name):
				var anim = gamedata.visual_effects[visdata.name]
				visdata.merge({
					"visual": anim
				})
				var vis = ActionVisual.new(visdata)
				visuals.append(vis)
	if actiondata.has("animation"):
		animation = actiondata.animation
	if actiondata.has("cooldown"):
		cooldown = actiondata.cooldown
	time = cooldown
	if actiondata.has("focus_cost"):
		focus_cost = actiondata.focus_cost
	if actiondata.has("bubbles"):
		for bubbledata in actiondata.bubbles:
			var bubble = SoundBubbleData.new(bubbledata)
			bubbles.append(bubble)

func cool_down(delta):
	if time > 0:
		time -= delta
	if time < 0:
		time = 0

func can_fire(target):
	var focus = has_focus()
	var range = in_range(target)
	return focus && range

func has_focus():
	var has = unit.stats.fuels.attention.value >= focus_cost
	return has
	
func in_range(pos):
	var distance = unit.global_position.distance_squared_to(pos)
	return distance <= (range * range)

func make_power():
	pass

#Extend this
func fire(target):
	pass
