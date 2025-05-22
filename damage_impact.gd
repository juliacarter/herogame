extends Impact
class_name DamageImpact

var damagetype = ""

var piercing = 0

func fire(target, crits = 0, flat_bonus = 0, percent_bonus = 0):
	var total_bonus = (percent_bonus / 100) * magnitude
	total_bonus += flat_bonus
	var potential = magnitude
	potential += total_bonus
	if crits > 0:
		var critbonus = potential * crits
		potential += critbonus
	var roll = randi() % potential
	var mod = (potential / 2) - roll
	var total = potential + mod
	target.take_hit(total, piercing, type, origin, "health")

func get_text():
	var result = String.num(magnitude) + " magnitude " + type + " damage"
	return result
