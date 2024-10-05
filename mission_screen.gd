extends Panel

@onready var rules = get_node("/root/WorldVariables")
@onready var grid = get_node("GridContainer")
@onready var missionview = get_node("MissionView")

@onready var unitlist = get_node("")

var buttonscene = load("res://mission_button.tscn")

var buttons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	load_encounters()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func clear_encounters():
	for i in range(buttons.size()-1,-1,-1):
		var button = buttons[i]
		buttons.pop_at(i)
		grid.remove_child(button)
	
func load_encounters():
	visible = true
	clear_encounters()
	var units = []
	
	for encounter in rules.available_missions:
		var button = buttonscene.instantiate()
		button.load_encounter(encounter)
		buttons.append(button)
		grid.add_child(button)

func open_mission(mission):
	missionview.load_mission(mission)
	missionview.visible = true

func _on_button_pressed():
	visible = false
