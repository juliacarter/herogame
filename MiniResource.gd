extends HBoxContainer

@onready var count = get_node("Count")

@onready var rules = get_node("/root/WorldVariables")

var resource = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	assign_count()

func assign_count():
	if rules.player.intangibles.has(resource):
		count.text = String.num(rules.player.intangibles[resource])
