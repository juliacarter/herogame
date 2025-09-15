extends Quest
class_name Threat




func assign_faction(new):
	faction = new

func _init(gamerules, threatdata):
	super(gamerules, threatdata)
	if threatdata.has("weight"):
		weight = threatdata.weight
		#if gamedata.quests_to_load.has(threatdata.questname):
			#quest = gamedata.quests_to_load[threatdata.questname]
			
func get_name():
	return "THREAT"
