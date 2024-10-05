extends Order
class_name ClearanceOrder

var spinbuttonscene = load("res://syntax_spin_button.tscn")

var clearance = 4

func return_join_effects():
	var effect_dict = {
		"effect": "add_clearance",
		"args": [clearance]
	}
	return effect_dict
	
func return_leave_effects():
	var effect_dict = {
		"effect": "remove_clearance",
		"args": [clearance]
	}
	return effect_dict

func buttons():
	var button = spinbuttonscene.instantiate()
	button.load_syntax(self, "clearance")
	return [button]

func name():
	return "Clearance"
