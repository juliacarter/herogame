extends Button

#parent panel to send the unit to
var parent

var unit

#whether to toggle or pick a single unit
var toggling = false

#whether the unit has been toggled on
var unit_toggled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	parent.pick_unit(unit)
