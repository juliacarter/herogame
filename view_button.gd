extends Button

@onready var rules = get_node("/root/WorldVariables")

var view

func load_view(newview):
	view = newview
	text = view.viewname

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	rules.load_view(view)
