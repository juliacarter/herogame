extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var encounterview = get_node("EncounterView")

@onready var encounterlist = get_node("EncounterList")



var sortables = [
	NameSortable.new()
]

var tabtitle = "encounters"

func get_window_title():
	return tabtitle

func load_encounters():
	if is_node_ready():
		var encounters = []
		encounterlist.load_sortables(rules.available_missions, sortables)

func load_encounter(new):
	encounterview.load_encounter(new)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rules.encounter_created.connect(load_encounters)
	load_encounters() # Replace with function body.
	encounterlist.select_row.connect(select_encounter)
	
func _exit_tree() -> void:
	rules.encounter_created.disconnect(load_encounters)
	
func select_encounter(row):
	load_encounter(row.object)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
