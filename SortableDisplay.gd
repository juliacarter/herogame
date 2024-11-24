extends Control
class_name SortableDisplay

var parent

var selector = false

var sortable

var object

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_display(newobj, newsort):
	sortable = newsort
	object = newobj
	display()

func display():
	pass
