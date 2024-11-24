extends ArcPhase
class_name ArcInvestigationPhase

#whether the phase should draw a random investigation for each mission
var random_investigation = false
#current position of drawn investigation, only if non-random
var current_pos = 0

var time_between_investigations = 0.0
var investigation_countdown = 0.0

#number of investigations the player needs to complete to progress the phase
#if -1, all investigations must be completed
var investigations_needed = -1

func start_investigation():
	var investigation = draw_investigation()
	if !random_investigation:
		current_pos += 1
	var mission = Quest.new(rules, rules.data.quests_to_load[investigation])
	var reward = ArcPhaseProgressReward.new(self)
	mission.rewards.append(reward)
	rules.start_mission(mission)

func draw_investigation():
	if random_investigation:
		var i = randi() % investigations.size()
	else:
		if current_pos < investigations.size():
			return investigations[current_pos]
