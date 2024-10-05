extends EncounterObjective
class_name WaveObjective

func make_encounter():
	if encounter == null:
		var enc = Wave.new(rules.data, encounterdata)
		var reward = QuestProgressReward.new(self)
		enc.enemy_bases = [
			rules.data.units.agent,
			rules.data.units.agent,
			rules.data.units.agent
		]
		enc.rules = rules
		enc.rewards.append(reward)
		enc.team_goals.merge({"coalition": encounterdata.objectivetype})
		enc.objectivetype = encounterdata.objectivetype
		enc.map = rules.home
		encounter = enc
	return encounter
	
func get_log_text():
	if !completed:
		return "wave " + encounterdata.objectivetype + ": " + String.num(completions) + "/" + String.num(needed)
	else:
		return "wave " + encounterdata.objectivetype + ": " + String.num(needed) + "/" + String.num(needed) + "!"
	
func start_objective():
	var enc = make_encounter()
	rules.start_wave("coalition", enc)
