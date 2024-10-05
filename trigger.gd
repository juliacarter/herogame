extends Object
class_name Trigger

var data

var action = ""
var args = []

var by_parent = false

var includes = false

var conditions = []

var time = ""
var key = ""

var rules

func _init(gamedata, trigdata):
	if trigdata.has("includes"):
		includes = trigdata.includes
	if trigdata.has("action"):
		action = trigdata.action
	if trigdata.has("args"):
		args = trigdata.args.duplicate()
	if trigdata.has("conditions"):
		for condata in trigdata.conditions:
			var condition = gamedata.make_condition(condata)
			conditions.append(condition)
	if trigdata.has("by_parent"):
		by_parent = trigdata.by_parent

func check_conditions(trigger_for, trigger_by):
	var result = true
	for condition in conditions:
		var triggering = trigger_for
		if condition.by_parent:
			triggering = trigger_for.parent
		if !condition.fits(triggering, trigger_by):
			result = false
	return result

func get_args(trigger_for, trigger_by):
	var result = args.duplicate()
	if includes:
		result.push_front(trigger_by)
		result.push_front(trigger_for)
	return result
