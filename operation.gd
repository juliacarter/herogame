extends Object
#class for containing units sent out by an npc faction
class_name Operation

#the faction that created the Operation
var faction

var units = []

#the role the faction takes when assigning units to encounters
var role = ""

var mission

#encounter to assign units in the Operation to
var encounter

func add_units(new):
	units = new.duplicate()
	for unit in units:
		encounter.add_unit(unit, role)
		
func assign_encounter(new):
	encounter = new
