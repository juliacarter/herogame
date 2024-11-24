extends Task
class_name MoveTask

var square



func _init(newsquare, newfinal):
	target = newfinal
	square = newsquare
	type = "move"
	during_combat = true

func get_square(origin = null, reserving = true, spotname = "move"):
	return square

func doable():
	return true

func save():
	var save_dict = {
		"targetsquare": {"x": square.x, "y": square.y},
		"type": type,
	}
	return save_dict
