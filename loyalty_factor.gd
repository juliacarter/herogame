extends Object
class_name LoyaltyFactor

signal factor_expired(factor)
signal factor_revealed(factor)

var value = 1

#chance of this Factor being discovered
var secrecy = 20

#expire the Factor when time > lifespan
var lifespan = 100
var time = 0

var known = false

var revealable = true

func _init(data):
	if data.has("value"):
		value = data.value
	if data.has("secrecy"):
		secrecy = data.secrecy
	if data.has("lifespan"):
		lifespan = data.lifespan
	
func think(delta):
	if time >= lifespan:
		expire()
	else:
		time += delta
	
func expire():
	factor_expired.emit(self)
