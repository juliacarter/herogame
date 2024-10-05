extends Object
class_name Link

var square

var cells = []

var diag = false

var tileweight = 2

var weight = 0.0

func _init(newcells, newsquare, newdiag = false):
	cells = newcells
	diag = newdiag
	square = newsquare
	if diag:
		weight = ((tileweight * tileweight) * 2)
	else:
		weight = tileweight * tileweight
	
#func weight(unit):
	#return weight
