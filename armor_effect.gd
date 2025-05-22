extends BaseEffect
class_name ArmorEffect

var armorname = ""

func _init(data):
	super(data)
	if data.has("armor"):
		armorname = data.armor

func apply_effect(unit, count):
	for i in count:
		unit.add_armor_by_name(armorname)
	
func remove_effect(unit, count):
	for i in count:
		unit.remove_armor_by_name(armorname)
