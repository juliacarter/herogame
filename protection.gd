extends Object
class_name Protection

var key = ""

var armor = {}
var durability
var maxdura

func _init(data):
	armor = data.armor.duplicate()
	maxdura = data.durability
	durability = maxdura
	if data.has("key"):
		key = data.key
	
#Returns the new damage
func get_defense(damage, type):
	if armor.has(type):
		var total = armor[type].min
		if armor[type].variance != 0:
			var bonus = randi() % armor[type].variance
			total += bonus
		return total
	else:
		return 0
	#if durability > 0:
		#durability -= damage
		#return armor
	#else:
		#return 0
