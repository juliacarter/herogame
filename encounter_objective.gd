extends Objective
class_name EncounterObjective

var key = ""

var encounter

var encounterdata

var completions = 0
var needed = 1

func _init(args, newquest = null):
	super(args, newquest)
	var encdata = rules.data.encounters[args.enc]
	key = args.enc
	encounterdata = encdata
	
	#Called every frame to see if the objective is complete
#Different implementation for different objective subclasses
func check_status():
	if !completed:
		if status_function():
			return complete()
		else:
			return false
	else:
		return true
	
func complete():
	completed = true
	return true
	
func status_function():
	return completions >= needed
	
#For EncounterObjective: add the desired Encounter to available encounters
func objective_started():
	make_encounter()
	
func start_objective():
	var enc = make_encounter()
	#enc.role_factions.baddies = quest.faction
	rules.quest_complete.connect(encounter.quest_complete)
	rules.start_encounter(enc, rules.factions.coalition)
	
func get_log_text():
	if !completed:
		return encounterdata.mapname + " " + encounterdata.team_goals.player + ": " + String.num(completions) + "/" + String.num(needed)
	else:
		return encounterdata.mapname + " " + encounterdata.team_goals.player + ": " + String.num(needed) + "/" + String.num(needed) + "!"
	
func make_encounter():
	if encounter == null:
		var enc = Encounter.new(rules, encounterdata)
		enc.encounter_begin.connect(step.quest.encounter_started)
		enc.return_map = rules.home
		enc.key = key
		enc.faction = step.quest.faction
		enc.quest = step.quest
		var reward = QuestProgressReward.new(self)
		enc.enemy_bases = [
			rules.data.units.agent,
			rules.data.units.agent,
			rules.data.units.agent
		]
		enc.rules = rules
		enc.rewards.append(reward)
		encounter = enc
		rules.encounter_created.emit(self)
	return encounter
