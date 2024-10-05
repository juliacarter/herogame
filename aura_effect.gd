extends BaseEffect
class_name AuraBaseEffect

var auradata = {}
var applied_effects = {}

func _init(data):
	super(data)
	type = "aura"
	if data.has("auradata"):
		auradata = data.auradata.duplicate()

func get_aura():
	return auradata
