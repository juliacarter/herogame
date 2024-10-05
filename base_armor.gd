extends BaseEquipment
class_name BaseArmor


func _init(data):
	super(data)
	protection = data.protection
	
func name():
	return itemname
