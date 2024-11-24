extends HBoxContainer

@onready var rules = get_node("/root/WorldVariables")

var displayscene = load("res://mini_resource.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_resources()

func update_resources():
	for key in rules.player.intangibles:
		var display = displayscene.instantiate()
		display.resource = key
		add_child(display)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
