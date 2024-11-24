extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var questlist = get_node("QuestList")

@onready var questinfo = get_node("Control/InnerWindow/QuestInfo")

var sortables = [
	NameSortable.new()
]

var tabtitle = "quests"

func get_window_title():
	return tabtitle

func load_quests():
	questlist.load_sortables(rules.quests, sortables)

func quest_complete(quest, success):
	load_quests()
	
func quest_started(quest):
	load_quests()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rules.quest_complete.connect(quest_complete)
	rules.quest_started.connect(quest_started)
	load_quests()

func _exit_tree() -> void:
	rules.quest_complete.disconnect(quest_complete)
	rules.quest_started.disconnect(quest_started)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_quest_list_select_row(row: Variant) -> void:
	open_quest(row.object)

func open_quest(quest):
	questinfo.load_quest(quest)
