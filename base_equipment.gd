extends BaseItem
class_name BaseEquipment

var slot = ""

var wearsprite

var equip_abilities = []

func _init(data):
	super(data)
	type = "equipment"
	slot = data.slot
	wearsprite = data.wearsprite

func name():
	return itemname
