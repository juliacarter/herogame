extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var list = get_node("MinimizableList")

var questscene = load("res://quest_entry.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_quests()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func load_quests():
	var quests = []
	for quest in rules.quests:
		var instance = questscene.instantiate()
		instance.set_quest(quest)
		quests.append(instance)
	list.load_items(quests)
