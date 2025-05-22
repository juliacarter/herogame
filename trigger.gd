extends Object
class_name Trigger

var rules
var data

var action = ""
var args = []

var outcomes = []

var by_parent = false

var includes = false

var conditions = []

#
var flip = false

var time = ""
var key = ""

var parent

func _init(gamedata, trigdata, newpar):
	rules = gamedata.rules
	parent = newpar
	data = gamedata
	if trigdata.has("includes"):
		includes = trigdata.includes
	if trigdata.has("action"):
		action = trigdata.action
	if trigdata.has("flip"):
		flip = trigdata.flip
	if trigdata.has("args"):
		args = trigdata.args.duplicate()
	if trigdata.has("outcomes"):
		for outcomedata in trigdata.outcomes:
			var outcome
			if outcomedata.has("type"):
				if rules.script_map.has(outcomedata.type):
					outcome = gamedata.make_outcome(outcomedata, self)
			else:
				outcome = Outcome.new(rules, outcomedata, self)
			if outcome != null:
				outcome.parent = self
				outcomes.append(outcome)
	if trigdata.has("conditions"):
		for condata in trigdata.conditions:
			var condition = gamedata.make_condition(condata)
			conditions.append(condition)
	if trigdata.has("by_parent"):
		by_parent = trigdata.by_parent

func fire(trigger_by):
	var pull = TriggerPull.new(self, trigger_by)
	pull.fire()

func check_conditions(trigger_for, trigger_by):
	var result = true
	for condition in conditions:
		var triggering
		var trying
		if !flip:
			triggering = trigger_for
			trying = trigger_by
		else:
			triggering = trigger_by
			trying = trigger_for
		if condition.by_parent:
			triggering = triggering.parent
		if !condition.fits(triggering, trying):
			result = false
	return result

func get_args(trigger_for, trigger_by):
	var result = args.duplicate()
	if !flip:
		result.push_front(trigger_by)
		result.push_front(trigger_for)
	else:
		result.push_front(trigger_for)
		result.push_front(trigger_by)
	return result
