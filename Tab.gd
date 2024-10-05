extends Button
class_name Tab

var parent

var index = 0
var tabtitle = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	parent.open_tab_index(index) # Replace with function body.
