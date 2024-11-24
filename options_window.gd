extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var reswidth = get_node("Width")
@onready var resheight = get_node("Height")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	var width = int(reswidth.text)
	var height = int(resheight.text)
	rules.change_resolution(width, height)
	
