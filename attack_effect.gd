extends BaseEffect
class_name AttackEffect

var attackname = ""

func _init(data):
	super(data)
	if data.has("weapon"):
		attackname = data.weapon

func apply_effect(unit, count):
	unit.add_weapon_by_name(attackname, count)
	
func remove_effect(unit, count):
	unit.remove_weapon_by_name(attackname, count)
