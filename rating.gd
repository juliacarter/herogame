extends Object
class_name Rating

var key = ""

var name = ""

var value = 0

func _init(ratingdata):
	pass

func increase_rating(amount):
	value += amount
	
func decrease_rating(amount):
	value -= amount
