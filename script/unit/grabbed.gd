extends Node3D
class_name Grabbed

var resource = {}
var item

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hold_resource(newresource):
	print("Holding:")
	print(resource)
	resource = newresource
	item = null
	
func hold_item(item):
	resource = null
	item = item
	
func drop():
	resource = null
	item = null
