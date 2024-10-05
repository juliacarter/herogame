extends Block
class_name Footprint

var content: Furniture

func save():
	var save_dict = {
		"type": "floor",
		"content": content.id
	}
	return save_dict

func assign_furniture(furniture):
	content = furniture
	
func get_furniture():
	return content

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func type():
	return "footprint"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
