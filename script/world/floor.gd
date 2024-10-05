extends Block
class_name Floor

func save():
	var save_dict = {
		"type": "floor",
		"datakey": "tile"
	}
	return save_dict

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func type():
	return "floor"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
