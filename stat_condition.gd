extends Criteria
class_name StatCondition


var target = ""

var direction = "greater"
var equalto = false
var statname = ""
var stattype = ""

var desired_percent = 0.0
#flat value added to or subtracted from percentage
var desired_flat = 0.0

var percentage = false

func _init(data):
	super(data)
	if data.has("statname"):
		statname = data.statname
	if data.has("stattype"):
		stattype = data.stattype
	if data.has("direction"):
		direction = data.direction
	if data.has("equalto"):
		equalto = data.equalto
		#Triggers if current stat is DIRECTION than desired
	if data.has("desired_percent"):
		desired_percent = data.desired_percent
	if data.has("desired_flat"):
		desired_flat = data.desired_flat
	if data.has("target"):
		target = data.target
	if data.has("percentage"):
		percentage = data.percentage
		
func check(unit):
	var per = (desired_percent / 100.0)
	var value = per * unit.stats[stattype][statname].max
	pass
	value += desired_flat
	if equalto:
		if unit.stats[stattype][statname].value == value:
			return true
	if direction == "greater":
		return unit.stats[stattype][statname].value > value
	if direction == "lesser":
		return unit.stats[stattype][statname].value < value
		
func fits(trigger_by, trigger_for = null):
	var result = true
	if target == "for":
		if !check(trigger_for):
			result = false
	elif target == "by":
		if !check(trigger_by):
			result = false
	return result
