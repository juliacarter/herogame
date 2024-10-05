extends Object
class_name DoomsdayPlot

var plotname = "nuke"
var stage = 0


var stages = {}

#format = {stage: [furn1, furn2, furn3]}
var stage_furniture = {}

var stage_jobs

#The overarching Quests that make up each step of the Doomsday Plan
var quests = []

func _init(gamedata, doomsdata):
	if doomsdata.has("plotname"):
		plotname = doomsdata.plotname
	if doomsdata.has("stage_furniture"):
		stage_furniture = doomsdata.stage_furniture.duplicate(true)
