extends Button

var item
var panel

var type = "ability"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func load_item(newability):
	item = newability
	text = item.base.key
