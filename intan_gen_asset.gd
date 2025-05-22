extends Asset
#an Asset that generates intangible resources over time
class_name IntanGenAsset

#name of the resource generated
var resource = "cash"

#amount of the resource generated per sec
var count = 1

func think(delta):
	var amount = count * delta
	rules.player.earn_intangible(resource, amount)
