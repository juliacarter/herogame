extends VBoxContainer

@onready var text = get_node("TextTip")

var last_tooltip

var tip

var parent
var origin

func load_tip(new):
	tip = new
	text.load_text(tip.text)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
