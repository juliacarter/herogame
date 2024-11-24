extends Object
class_name UnitList

var faction: Faction

var units = {}
var weights = {}

var role = ""

func _init(data):
	if data.has("weights"):
		weights = data.weights.duplicate()
	if data.has("units"):
		units = data.units.duplicate()
		
func generate_units(value, max = -1):
	var remaining = value
	var genned = []
	var done = false
	while !done:
		var wheel = []
		if max == -1 || genned.size() < max:
			for key in units:
				var weight = weights[key]
				var wizard = units[key]
				if remaining - wizard.starting_price >= 0:
					for i in weight:
						wheel.append(key)
			if wheel != []:
				var rand = randi() % wheel.size()
				var key = wheel[rand]
				var wizard = units[key]
				var result = wizard.generate_unit(remaining)
				if result != null:
					remaining -= result.cost
					genned.append(result.unit)
			else:
				done = true
		else:
			done = true
	return genned

func generate_amount(count):
	var wheel = []
	var results = []
	for key in units:
		var weight = units[key]
		for i in weight:
			wheel.append(key)
	for i in count:
		var rand = randi() % wheel.size()
		var result = wheel[rand]
		results.append(result)
	return results
