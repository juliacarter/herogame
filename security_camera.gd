extends Object
class_name SecurityCamera

var rules

var monitoring = false

var camerapower = 1

var id

var furniture

# Called when the node enters the scene tree for the first time.


func monitor(newmon):
	monitoring = newmon
	if !monitoring:
		furniture.clear_sight()
