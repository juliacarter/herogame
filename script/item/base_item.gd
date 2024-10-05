extends Object
class_name BaseItem

var id

var itemname
var size
var categories

var type = "item"

var sprite

var price

var protection
var attack

var key

#Pooled items don't care about container location. They are added to and taken directly from the player's stockpiles. An example is Cash
var pooled = false

func name():
	return itemname

func _init (data):
	itemname = data.name
	size = data.size
	if data.has("sprite"):
		sprite = data.sprite
	else:
		sprite = "thang"
	if data.price != null:
		price = data.price
	categories = data.cat
