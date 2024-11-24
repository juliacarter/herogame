extends Control

@onready var abilitylist = get_node("VBoxContainer/AbilityList")

@onready var actionlist = get_node("VBoxContainer/ActionList")

@onready var lessons = get_node("LessonPicker")

var tabtitle = "Abilities"

var sortables = [
	NameSortable.new(),
	CountSortable.new(),
]

var unit

func load_unit(new):
	unit = new
	
	
func load_actions():
	var actions = unit.action_priority.actions
	actionlist.load_items(actions)
	
func load_abilities():
	var options = []
	for key in unit.abilities:
		var ability = unit.abilities[key]
		options.append(ability)
	if unit != null:
		abilitylist.load_sortables(options, sortables)
	else:
		print("Unit not loaded!")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_abilities()
	load_actions()
	actionlist.item_moved.connect(move_action)

func move_action(item, amount):
	unit.action_priority.modify_action_prio(item.action, amount)
	load_actions()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_lesson_button_pressed() -> void:
	lessons.visible = true
	lessons.load_unit(unit)
