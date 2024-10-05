extends SyntaxSlotButton
class_name SyntaxCheckButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.button_pressed = syntax.aggression


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func load_syntax(syntax, slot):
	super(syntax, slot)
	pass


func _on_button_toggled(toggled_on: bool) -> void:
	value = toggled_on
