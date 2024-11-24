extends Object
class_name Quest

var title = ""
var description = "Lorem ipsum odor amet, consectetuer adipiscing elit. Aliquam fusce nec augue orci ad. Metus aenean molestie suspendisse netus scelerisque congue est fermentum. Lorem montes amet libero pellentesque; posuere class. Pulvinar molestie elit tellus, auctor amet sociosqu. Etiam ipsum sapien eget non; vitae pretium laoreet. Arcu lectus quis laoreet conubia est adipiscing taciti duis parturient. Arcu maximus euismod, vestibulum suscipit nulla cras. Adis dui porta praesent per hendrerit."

var completed = false

#flip this when encounter starts to stop timer
var started = false

var rules

var current_step = 0
var steps = []

var on_complete = ""
var complete_args = []

var rewards = []
#Rewards that fire when the Quest is failed
var fail_effects = []

#the region the Quest is attached to, if any
var region

#Faction associated with the quest, if any
var faction
#research granted to this Quest's faction if failed
var research_on_fail = 10

#whether or not this Quest shows up in the Log
var visible = true

#the Scheme, Opportunity, Threat, or Plot the quest is part of
var source

#Time the player has to complete the Quest
var time = -100

var pindata

var pin

signal quest_complete(quest, success)

func encounter_started():
	started = true

func get_log_entry():
	return title + "\n\n" + description

func think(delta):
	if time != -100 && !started:
		time -= delta
		if time <= 0:
			fail()

func _init(newrules, args):
	pindata = QuestPinData.new(self)
	rules = newrules
	if args.has("time"):
		time = args.time
	if args.has("name"):
		title = args.name
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

func object_name(l=""):
	return title

func get_name():
	return title

func start_quest():
	var step = steps[0]
	step.start_step()
	rules.quest_started.emit(self)

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
	if faction != null:
		faction.gain_research(research_on_fail)
	rules.fail_quest(self)
	rules.quest_complete.emit(self, false)
	
func complete():
	
	completed = true
	if region != null:
		region.scheme_active = false
	rules.complete_quest(self)
	rules.quest_complete.emit(self, true)
