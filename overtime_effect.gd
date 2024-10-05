extends BaseEffect
class_name OvertimeEffect

var damage = {}

func _init(data):
	if data.has("damage"):
		damage = data.damage.duplicate()
	type = "overtime"
