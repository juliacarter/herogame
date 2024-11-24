extends Object
class_name Upgrade

var base

var source = "nosource"

func object_name(length = ""):
	return base.object_name(length)

func _init(newbase, newsource):
	base = newbase
	source = newsource
