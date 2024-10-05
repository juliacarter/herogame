extends SyntaxSlotButton
class_name SyntaxSpinButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.value = syntax.get(slot)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_syntax(syntax, slot):
	super(syntax, slot)


func _on_button_value_changed(num: float) -> void:
	value = int(num)
