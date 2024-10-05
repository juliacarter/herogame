extends Panel

@onready var rules = get_node("/root/WorldVariables")

@onready var xfield = get_node("Xfield")
@onready var yfield = get_node("Yfield")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	rules.new_game_new_map(xfield.value, yfield.value)
