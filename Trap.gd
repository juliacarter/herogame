extends Object
class_name Trap

var rules

var footprintspotterscene = load("res://footprint_spotter.tscn")
var conespotterscene = load("res://cone_spotter.tscn")

var furniture

var difficulty = 60

var spotters = {
	#"walkon": footp
}

var spotted = {}
var trapped = {}

var rolls = {}

var retriggertimers = {}

var triggers = {
	"on_trapping": {
		"action": "effect_on",
		"args": ["spiketrap"]
	}
}
	
func load_trap(trap):
	pass

func trigger(trigger_name, triggered_by):
	if triggers.has(trigger_name):
		var action = triggers[trigger_name].action
		var args = triggers[trigger_name].args.duplicate()
		args.append(triggered_by)
		rules.callv(action, args)
		
func trap_check(unit):
	var result = unit.roll(["attention"])
	if result < difficulty:
		trigger("on_trapping", unit)
		
func enter_trap(area):
	spotted.merge({
		area.id: area
	})
	trap_check(area)
	
func exit_trap(area):
	spotted.erase(area)
