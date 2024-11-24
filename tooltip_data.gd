extends Object
class_name TooltipData

var title = ""

var text = ""

var tips = []

#mouse needs to hover over tooltip for at least this long to activate it
var hover_time = 0.0
var time = 0.0

func _init(tipdata):
	if tipdata.has("text"):
		text = tipdata.text
	if tipdata.has("title"):
		title = tipdata.title
	if tipdata.has("tips"):
		tips = tipdata.tips.duplicate()
