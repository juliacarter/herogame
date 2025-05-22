extends Object
#a single-shot action that runs through the Rules
class_name Outcome

var rules
var data

var parent

#function called when event fires
var function = ""

#args for event funt
var args = []

func _init(newrules, eventdata, newpar = null):
	parent = newpar
	rules = newrules
	data = rules.data
	if eventdata.has("args"):
		args = eventdata.args.duplicate()
	if eventdata.has("action"):
		function = eventdata.action
		
func fire(target):
	rules.callv(function, args)
