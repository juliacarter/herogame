extends Control

@onready var rewards = get_node("HBoxContainer/ScrollContainer/VBoxContainer/QuestRewardDisplay")
@onready var textbox = get_node("HBoxContainer/ScrollContainer/VBoxContainer/TippableRichText")

@onready var timer = get_node("HBoxContainer/ScrollContainer/VBoxContainer/TimerBar")

var quest

func load_quest(new):
	quest = new
	textbox.load_text(quest.get_log_entry())
	rewards.load_quest(quest)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if quest != null:
		timer.max_value = quest.time_cap
		timer.value = quest.time
