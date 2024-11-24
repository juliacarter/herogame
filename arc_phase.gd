extends Object
class_name ArcPhase

var rules
var data

var arc

#start all of these quests when starting the Phase, and assign the Arc as source
var quests = []

#threats that can be drawn when this Phase is active
var threats = {}

#Investigations that can be drawn during this Phase
var investigations = []

#the number of Phase Quests completed
var current_progress = 0

var needed = 1

func get_threat(type = "DoomThreat"):
	if threats.has(type) && threats[type] != []:
		var i = randi() % threats[type].size()
		var threat = threats[type][i]
		return threat
	return null
	
func investigate(delta):
	pass
	
func draw_investigation():
	if investigations != []:
		var i = randi() % investigations.size()
		var inv = investigations[i]
		return inv
	return null

func start_phase():
	for questname in quests:
		
		var quest = rules.start_quest(questname)
		arc.quests.append(quest)
		quest.source = self
		var reward = ArcPhaseProgressReward.new(self)
		
		quest.rewards.append(reward)
		rules.interface.arcpreview.load_arc(arc)
	
	#rules.interface.questlist.load_quests()
		
func _init(newrules, phasedata, newarc):
	rules = newrules
	data = rules.data
	arc = newarc
	if phasedata.has("quests"):
		quests = phasedata.quests.duplicate()
	if phasedata.has("investigations"):
		for invname in phasedata.investigations:
			var invdata = data.missions_to_load[invname]
			var investigation = Investigation.new(data, invdata, self)
			investigations.append(investigation)
	if phasedata.has("threats"):
		for threatname in phasedata.threats:
			var threatdata = data.missions_to_load[threatname]
			var threat
			if threatdata.has("type"):
				var threattype = rules.script_map[threatdata.type]
				threat = threattype.new(data, threatdata, self)
			else:
				threat = Threat.new(data, threatdata, self)
			threats.merge({
				threatdata.type: []
			})
			threats[threatdata.type].append(threat)
	needed = quests.size()
	
func increase_doom():
	arc.increase_doom()
	
func progress(amount):
	current_progress += amount
	if current_progress >= needed:
		arc.next_phase()
		
func get_name():
	return arc.get_name()
