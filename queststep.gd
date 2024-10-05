extends Object
class_name QuestStep

var rules

var complete = false
var active = true

var objectives = []

var rewards = []

func _init(newrules, newquest, newobj, newrew = []):
	rules = newrules
	var objs = []
	for reward in newrew:
		rewards.append(reward)
	for obj in newobj:
		var args = obj.args.duplicate()
		args.merge({
			"step": self,
			"rules": rules
		})
		var objective = rules.instantiate_class(obj.type, args)
		objs.append(objective)
	objectives = objs
	#objectives = [ResourceObjective.new(rules, self, "cash", 200)]
	
func start_step():
	for obj in objectives:
		obj.start_objective()

func complete_step():
	rules.complete_step(self)

func check_completion():
	var done = true
	for objective in objectives:
		if !objective.check_status():
			done = false
	complete = done
	return done
