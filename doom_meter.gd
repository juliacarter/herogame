extends TextureProgressBar

@onready var rules = get_node("/root/WorldVariables")

@onready var label = get_node("Label")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if rules.active_arc != null:
		max_value = rules.active_arc.max_doom
		var doom = rules.active_arc.doom
		value = doom
		label.text = "DOOM:" + String.num(doom) + "/" + String.num(max_value)
	else:
		label.text = "IT'S CALM."
