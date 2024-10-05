extends Power
class_name AbilityPower

var ability: Ability

func _init(data):
	super(data)
	if data.has("ability"):
		ability = data.ability

func altclick():
	ability.autocast = !ability.autocast
