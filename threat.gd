extends Object
class_name Threat

#quest to start when the Threat is created
var quest = ""

var weight = 1

func _init(gamedata, threatdata):
	if threatdata.has("weight"):
		weight = threatdata.weight
	if threatdata.has("questname"):
		quest = threatdata.questname
		#if gamedata.quests_to_load.has(threatdata.questname):
			#quest = gamedata.quests_to_load[threatdata.questname]
