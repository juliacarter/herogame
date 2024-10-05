extends Block
class_name Edge


func save():
	var save_dict = {
		"type": "edge",
		"datakey": "border"
	}
	return save_dict

# Called when the node enters the scene tree for the first time.
func _ready():
	#nav.enabled = false
	pass

func type():
	return "edge"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
