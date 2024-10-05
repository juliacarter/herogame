extends HBoxContainer

@onready var rules = get_node("/root/WorldVariables")

@onready var label = get_node("Label")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = String.num(rules.factions.coalition.heat)
