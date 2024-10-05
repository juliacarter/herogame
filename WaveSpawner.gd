extends Panel

@onready var rules = get_node("/root/WorldVariables")
@onready var data = get_node("/root/Data")

@onready var factionselect = get_node("FactionSelector")
@onready var objectiveselect = get_node("ObjectiveSelector")

@onready var grid = get_node("WaveGrid")

var buttonscene = load("res://wave_spawn_button.tscn")

var buttons = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_objectives():
	objectiveselect.add_item("default")
	objectiveselect.add_item("killall")
	objectiveselect.add_item("destroy")
	objectiveselect.add_item("spy")
	objectiveselect.add_item("steal")
	
func load_factions():
	factionselect.add_item("default")
	for key in rules.factions:
		factionselect.add_item(key)

func clear_waves():
	for i in range(buttons.size()-1,-1,-1):
		var button = buttons[i]
		grid.remove_child(button)
		buttons.pop_at(i)

func load_waves():
	clear_waves()
	for key in data.encounters:
		var encounter = data.encounters[key]
		if encounter.type == "wave":
			var button = buttonscene.instantiate()
			button.load_wave(encounter)
			button.panel = self
			buttons.append(button)
			grid.add_child(button)
			
func spawn_wave(wave):
	var faction = factionselect.get_item_text(factionselect.selected)
	var objective = objectiveselect.get_item_text(objectiveselect.selected)
	rules.spawn_wave(wave, faction, objective)
