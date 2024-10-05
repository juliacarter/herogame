extends BaseEffect
class_name ArmorEffect

var armorname = ""

func _init(data):
	super(data)
	if data.has("armor"):
		armorname = data.armor
