extends Control

@onready var rules = get_node("/root/WorldVariables")
@onready var data = get_node("/root/Data")

@onready var label = get_node("HBoxContainer/VBoxContainer/Label")
@onready var bar = get_node("HBoxContainer/VBoxContainer/ProgressBar")

@onready var tooltip = get_node("HBoxContainer/Button/TooltipArea")

var stat

func load_stat(new):
	stat = new
	tooltip.tooltip = data.tooltips["testtip"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_mouse_entered() -> void:
	#rules.interface.mouserig.set_tooltip("stat tooltip")
	pass


func _on_button_mouse_exited() -> void:
	#rules.interface.mouserig.clear_tooltip()
	pass
