extends PinData
class_name QuestPinData

var quest

func _init(newquest):
	quest = newquest
	
func get_data():
	return {
		"name": quest.object_name(),
		"location": quest
	}
