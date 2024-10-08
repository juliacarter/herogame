extends Object
class_name Quest

var completed = false

#flip this when encounter starts to stop timer
var started = false

var rules

var current_step = 0
var steps = []

var on_complete = ""
var complete_args = []

var rewards = []

var fail_effects = []

var region

#whether or not this Quest shows up in the Log
var visible = true

#the Scheme, Opportunity, Threat, or Plot the quest is part of
var source

#Time the player has to complete the Quest
var time = -100

func think(delta):
	if time != -100 && !started:
		time -= delta
		if time <= 0:
			fail()

func _init(newrules, args):
	rules = newrules
	if args.has("time"):
		time = args.time
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
	if args.has("fail_effects"):
		for reward in args.fail_effects:
			var newfail = rules.script_map[reward.type].new(reward.args)
			newfail.parent = self
			fail_effects.append(newfail)
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
	
func fail():
	completed = true
	if region != null:
		region.scheme_active = false
	rules.fail_quest(self)
	
func complete():
	completed = true
	if region != null:
		region.scheme_active = false
	rules.complete_quest(self)
