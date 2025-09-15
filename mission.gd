extends Object
class_name Mission

var rules

#WHEN A MISSION IS STARTED:
#begin encounter at steps[0]
#send assigned units to steps[0]
#when steps[0] is complete, move to next step and send assigned units there
#repeat

var steps = []

var units = {}

var step = 0

var started = false

func assign_units(new, faction):
	units.merge({
		faction: {}
	})
	units[faction].merge(new)
	
func assign_unit(new, faction):
	units.merge({
		faction: {}
	})
	units[faction].merge({new.id: new})
	pass
	
#send assigned Units to steps[0]
#requires travel via transport
func start_mission():
	var encounter = steps[step]
	encounter.assign_units_to_role(units[rules.factions.player].values(), "player")
	rules.start_mission(encounter)
	step += 1
	
#increment Step, then send assigned units to next encounter
#units are instantly teleported
func next_encounter():
	var encounter = steps[step]
	encounter.assign_units_to_role(units[rules.factions.player].values(), "player")
	rules.start_mission_skip_send(encounter)
	encounter.teleport_units(units[rules.factions.player].values())
	step += 1
	
#send units home
func finish_mission():
	pass

func _init(gamerules, missiondata, newparent = null):
	rules = gamerules
	if missiondata.has("steps"):
		for stepname in missiondata.steps:
			var step = rules.new_encounter_by_name(stepname)
			step.mission = self
			steps.append(step)
	
func object_name(l="short"):
	return "MISSION"
	
func get_description():
	return "This is a mission where you do a cool thing."
