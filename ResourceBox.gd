extends HBoxContainer
class_name ResourceBox

@onready var rules = get_node("/root/WorldVariables")

@onready var label = get_node("Label")

var resource = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if rules.player.intangibles.has(resource):
		label.text = String.num(rules.player.intangibles[resource])

func load_resource(new):
	resource = new
