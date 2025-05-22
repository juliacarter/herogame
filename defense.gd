extends Object
class_name Defense

var protections = []

var armor = {
	"physical": {"min": 0, "variance": 0},
	"energy": {"min": 0, "variance": 0}
}

func clear_protection():
	protections = []
	calculate_armor()

func add_protection(new):
	protections.append(new)
	calculate_armor()
	
func remove_protection(removekey):
	for i in protections.size():
		var prot = protections[i]
		if prot.key == removekey:
			protections.pop_at(i)
			return
	
#Returns the amount that is subtracted from the final damage value
func get_defense(damage, piercing, type, attack = null):
	if !armor.has(type):
		return 0.0
	var value = float(armor[type].min)
	value -= piercing
	if armor[type].variance != 0.0:
		var rand = randi()% armor[type].variance
		value += float(rand)
	#if value <= damage:
		#return 0.0
	if value < 0:
		value = 0
	var percent = value / 100
	var amount = damage * percent
	return amount
	
func calculate_armor():
	armor = {
		"physical": {"min": 0, "variance": 0},
		"energy": {"min": 0, "variance": 0}
	}
	for prot in protections:
		for key in prot.armor:
			var val = prot.armor[key]
			add_armor(key, val.min, val.variance)
		
func add_armor(type, min, variance):
	if armor.has(type):
		armor[type].min += min
		armor[type].variance += variance
	else:
		armor.merge({
			type: {
				"min": min,
				"variance": variance,
			}
		})
