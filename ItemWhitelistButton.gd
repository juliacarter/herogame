extends CheckBox

var key = ""
var shelf: Shelf

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func load_item(newkey, newshelf):
	key = newkey
	text = key
	shelf = newshelf


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		shelf.add_whitelist(key)
	else:
		shelf.remove_whitelist(key)
