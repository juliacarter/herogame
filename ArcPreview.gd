extends Control

@onready var list = get_node("MinimizableList")

var arc

var questscene = load("res://quest_entry.tscn")

func load_arc(new):
	if new != null:
		arc = new
		var scenes = []
		for quest in arc.quests:
			var scene = questscene.instantiate()
			scene.set_quest(quest)
			scenes.append(scene)
		list.load_items(scenes)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
