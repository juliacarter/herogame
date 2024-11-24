extends PinData
class_name EncounterPinData

var encounter

func _init(newencounter):
	encounter = newencounter
	
func get_data():
	return {
		"name": encounter.object_name(),
		"location": encounter
	}
