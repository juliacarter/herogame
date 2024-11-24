extends Object
class_name Mission

#the source of this Mission, usually an ArcPhase
var parent

#quest to start when the Threat is created
var quest = ""

var weight = 1

var fail_effects = []
var success_effects = []

func _init(gamedata, threatdata, newparent = null):
	parent = newparent
	if threatdata.has("weight"):
		weight = threatdata.weight
	if threatdata.has("questname"):
		quest = threatdata.questname
	
func get_name():
	return "MISSION"
