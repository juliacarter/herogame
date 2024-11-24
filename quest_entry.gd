extends Control

@onready var label = get_node("content/Label")
@onready var arclabel = get_node("content/ArcName")

@onready var steps = get_node("content/Steps")

@onready var contentholder = get_node("content")

var stepscene = load("res://quest_step.tscn")

var quest

signal modified

func set_quest(new):
	quest = new

func load_quest(new):
	quest = new
	update_entry()
	for step in quest.steps:
		var instance = stepscene.instantiate()
		steps.add_child(instance)
		instance.load_step(step)
	#set_custom_minimum_size(contentholder.size + Vector2(0, 50))
	#modified.emit()

func update_entry():
	label.text = quest.get_name()
	if quest.source != null:
		arclabel.text = quest.source.get_name()
	#set_custom_minimum_size(contentholder.size + Vector2(0, 50))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if quest != null:
		load_quest(quest)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
