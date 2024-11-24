extends Condition
class_name ClassCriteria

var classes = []

func fits(unit, target = null):
	var result = false
	for unitclass in classes:
		if unit.unit_class.classname == unitclass.classname:
			result = true
	return result
	
func _init():
	pass

#func buttons():
	#var button = buttonscene.instantiate()
	#button.load_syntax(self, "classes")
	#button.multi = true
	#return [button]

func name():
	return "Class"
