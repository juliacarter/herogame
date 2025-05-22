extends Object
class_name WeightedRollTable

#items by weight
var items = {
}

#if an item can't be repeated while rolling multiple rolls, add here and make true
#if an item is not here, assume it can repeat
var no_repeat = {
	
}

func _init(newitems, newrepeat = {}):
	items = newitems.duplicate()

#if count=-1, roll number of drops
func roll(count = -1):
	var rolls = 0
	if count != -1:
		rolls = count
	else: rolls = 3
	var result = []
	var found = 0
	result.resize(rolls)
	var size = 0
	for key in items:
		var weight = items[key]
		size += weight
	var options = []
	var pos = 0
	if size != 0:
		options.resize(size)
		for key in items:
			var weight = items[key]
			for i in weight:
				options[pos] = key
				pos += 1
		for i in rolls:
			var rand = randi() % size
			result[i] = options[rand]
	return result
