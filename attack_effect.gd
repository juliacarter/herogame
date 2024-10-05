extends BaseEffect
class_name AttackEffect

var attackname = ""

func _init(data):
	super(data)
	if data.has("weapon"):
		attackname = data.weapon
