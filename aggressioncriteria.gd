extends Criteria
class_name AggressionCriteria

var checkbuttonscene = load("res://syntax_check_button.tscn")

var aggression = true

func _init(value = true):
	pass

func fits(unit, target = null):
	return unit.aggressive == aggression

func buttons():
	var button = checkbuttonscene.instantiate()
	button.load_syntax(self, "aggression")
	return [button]
	
func name():
	return "Aggression"
