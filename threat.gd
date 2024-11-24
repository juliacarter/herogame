extends Mission
class_name Threat



var faction



func _init(gamedata, threatdata, newparent = null):
	super(gamedata, threatdata, newparent)
	parent = newparent
	if threatdata.has("weight"):
		weight = threatdata.weight
	if threatdata.has("questname"):
		quest = threatdata.questname
		#if gamedata.quests_to_load.has(threatdata.questname):
			#quest = gamedata.quests_to_load[threatdata.questname]
			
func get_name():
	return "THREAT"
