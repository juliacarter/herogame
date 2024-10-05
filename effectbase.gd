extends Object
class_name BaseEffect

var modifiers = {}
var toggles = {}

var triggers = {}

var type = "mod"

var effname = ""

var allows_negative = false

func _init(data):
	if data.has("modifiers"):
		modifiers = data.modifiers.duplicate()
	if data.has("toggles"):
		toggles = data.toggles.duplicate()
		
func get_modifiers():
	return modifiers
