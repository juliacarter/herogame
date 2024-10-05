extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var button = get_node("Button")

var region

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_region(new):
	region = new
	button.text = region.id


func _on_button_pressed() -> void:
	rules.interface.open_region(region)
