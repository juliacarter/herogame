extends Control

@onready var lockprog = get_node("HBoxContainer2/ProgressBar")

@onready var title = get_node("HBoxContainer2/Label2")

var tooltip

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tooltip != null:
		if !tooltip.locked:
			lockprog.max_value = 1.0
			lockprog.value = tooltip.lock_timer
		else:
			lockprog.max_value = 22.0
			lockprog.value = tooltip.unlock_timer
			
func load_tip(tipdata):
	title.text = tipdata.title
