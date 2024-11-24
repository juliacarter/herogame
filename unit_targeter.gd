extends Targeter
#simple targeter that returns a single unit
#returns closest unit to the origin
class_name UnitTargeter


func manual_target():
	var unit = rules.get_unit_under_mouse()
	return unit
