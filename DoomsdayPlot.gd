extends Plot
class_name DoomsdayPlot

var plotname = "nuke"




func _init(gamedata, doomsdata):
	if doomsdata.has("plotname"):
		plotname = doomsdata.plotname
	if doomsdata.has("stage_furniture"):
		stage_furniture = doomsdata.stage_furniture.duplicate(true)
