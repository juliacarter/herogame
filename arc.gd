extends Object
class_name Arc

var key

var rules

var current_phase = 0

var phases = []

#Rewards for completing the arc, if any
var rewards = []

#the amount of Doom this arc currently has built up
var doom = 0
#the maximum amount of Doom before the campaign fails
var max_doom = 2

#currently active quests started by this arc
var quests = []

func investigate(delta):
	var phase = get_current_phase()
	if phase != null:
		phase.investigate(delta)

func get_current_phase():
	return phases[current_phase]

func increase_doom():
	doom += 1
	if doom >= max_doom:
		rules.lose_game()

func _init(gamerules, arcdata):
	rules = gamerules
	if arcdata.has("phases"):
		var options = arcdata.phases
		for phasedata in arcdata.phases:
			var phase = ArcPhase.new(rules, phasedata, self)
			#phase.arc = self
			phases.append(phase)

func get_name():
	return key

func next_phase():
	current_phase += 1
	start_phase()
		
func start_phase():
	if current_phase <= (phases.size() - 1):
		var phase = phases[current_phase]
		phase.start_phase()
	elif current_phase >= phases.size():
		complete_arc()
		
func complete_arc(success = true):
	rules.complete_arc(self, success)

func begin_arc():
	current_phase = 0
	if phases != []:
		start_phase()
	else:
		print("ARC IMPROPERLY CONSTRUCTED")
