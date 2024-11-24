extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var questholder = get_node("Quests")

var quests = []

var tabtitle = "quests"

func get_window_title():
	return tabtitle

func load_quests():
	for quest in rules.quests:
		pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
