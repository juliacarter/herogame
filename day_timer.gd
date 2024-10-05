extends HBoxContainer

@onready var rules = get_node("/root/WorldVariables")

@onready var bar = get_node("ProgressBar")
@onready var button = get_node("Button")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bar.value = rules.daytimer
