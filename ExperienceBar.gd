extends Control

@onready var bar = get_node("ProgressBar")

@onready var amountlabel = get_node("ProgressBar/Amount")
@onready var levellabel = get_node("ProgressBar/Level")

var unit

func load_unit(new):
	unit = new

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if unit != null:
		var needed = unit.needed_experience
		var current = unit.experience
		bar.max_value = needed
		bar.value = current
		levellabel.text = "Lv." + String.num(unit.level)
		amountlabel.text = String.num(current) + "/" + String.num(needed)


func _on_button_pressed() -> void:
	unit.level_up()
