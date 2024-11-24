extends Button

var base

var unit

signal lesson_picked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_lesson(newupg, newunit):
	unit = newunit
	base = newupg
	text = base.key


func _on_pressed() -> void:
	unit.learn_lesson(base)
	lesson_picked.emit()
