extends Outcome
#an Outcome that applies a set of Impacts, like a one-shot Attack
class_name ImpactOutcome

var impacts = []

func _init(newrules, eventdata, newpar):
	super(newrules, eventdata, newpar)
	if eventdata.has("impacts"):
		for impactdata in eventdata.impacts:
			pass
