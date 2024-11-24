extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var list = get_node("MinimizableList")

var questscene = load("res://quest_entry.tscn")

var listscene = load("res://minimizable_list.tscn")

var arcscene = load("res://arc_preview.tscn")

var tabtitle = "quests"

func get_window_title():
	return tabtitle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_quests()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func load_quests():
	var scenes = []
	var threats = []
	for mission in rules.missions:
		if mission is Arc:
			var scene = arcscene.instantiate()
			scenes.append(scene)
		elif mission is Threat:
			threats.append(mission)
	if threats != []:
		pass
	list.load_items(scenes)
