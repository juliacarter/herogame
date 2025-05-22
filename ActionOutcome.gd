extends Outcome
#fires an Action a single time at the target
class_name ActionOutcome

var action

var actname = ""

func _init(newrules, outcomedata, newpar):
	super(newrules, outcomedata, newpar)
	if outcomedata.has("action"):
		actname = outcomedata.action
		#action = data.make_action(actname, parent)
		#action.unit = parent.parent
			
func fire(target):
	action = data.make_action(actname, parent.parent)
	action.unit = parent.parent
	action.cast(1.0, target)
