extends Object
class_name Quest

var completed = false

var rules

var current_step = 0
var steps = []

var on_complete = ""
var complete_args = []

var rewards = []

var region

func _init(newrules, args):
	rules = newrules
	if args.has("rewards"):
		for reward in args.rewards:
			var newreward = rules.script_map[reward.type].new(reward.args)
			newreward.parent = self
			rewards.append(newreward)
	for step in args.steps:
		var newrew = []
		if step.has("rewards"):
			for reward in step.rewards:
				var newreward = rules.script_map[reward.type].new(reward.args)
				newreward.parent = self
				newrew.append(newreward)
		var newstep = QuestStep.new(rules, self, step.objectives, newrew)
		steps.append(newstep)
	#steps = [QuestStep.new(rules, self, newobj)]

func start_quest():
	var step = steps[0]
	step.start_step()

func check_quest():
	var done = true
	if current_step < steps.size():
		var step = steps[current_step]
		if !step.check_completion():
			done = false
		if done && !completed:
			step.complete_step()
			next_step()
	return done
	
func next_step():
	current_step += 1
	if current_step < steps.size():
		var step = steps[current_step]
		step.start_step()
		check_quest()
	else:
		complete()
	
func complete():
	completed = true
	if region != null:
		region.scheme_active = false
	rules.complete_quest(self)
