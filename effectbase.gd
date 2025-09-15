extends Object
class_name BaseEffect

var modifiers = {}
var toggles = {}

var triggers = {}

var type = "mod"

var effname = ""

var allows_negative = false

var oneshot = false

var ticking = false

func _init(data):
	if data.has("modifiers"):
		modifiers = data.modifiers.duplicate()
	if data.has("toggles"):
		toggles = data.toggles.duplicate()
		
func get_modifiers():
	return modifiers

func apply_effect(unit, count):
	for i in count:
		unit.add_mods(modifiers)
		unit.add_triggers(triggers)
	
func remove_effect(unit, count):
	for i in count:
		unit.remove_mods(modifiers)
		for key in triggers:
			var trigger = triggers[key]
			unit.remove_trigger(trigger)
			
func tick(delta, on, stacks):
	pass
