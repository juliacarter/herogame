extends Button

@onready var label = get_node("Label")

var sortable

var parent

func load_sort(new):
	sortable = new
	text = sortable.title

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	parent.sort_pushed(sortable)
