extends PinData
class_name WorksitePinData

var worksite

func _init(newwworksite):
	worksite = newwworksite
	
func get_data():
	return {
		"name": worksite.object_name(),
		"location": worksite
	}
