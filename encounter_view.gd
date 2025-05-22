extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var body = get_node("VBoxContainer/InnerWindow/ScrollContainer/Body")

@onready var label = get_node("VBoxContainer/InnerWindow/ScrollContainer/Body/Label")

@onready var unitlist = get_node("VBoxContainer/SortableList")


var sortables = [
	NameSortable.new(),
	LevelSortable.new(),
	ClassNameSortable.new(),
	CheckboxSortable.new()
]

var encounter

var selected_units = {}


func load_encounter(new):
	encounter = new
	label.text = encounter.get_description()
	load_units()

func load_units():
	var units = []
	for key in rules.home.units:
		var unit = rules.home.units[key]
		units.append(unit)
	unitlist.load_sortables(units, sortables)
	#if encounter != null:
		#unitlist.load_sortables(encounter.units.values(), sortables)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unitlist.toggle_row.connect(toggle_row)
	
func toggle_row(row):
	pass

func commit_list():
	var rows = unitlist.selected
	for row in rows:
		var unit = row.object
		encounter.assign_unit(unit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	commit_list()
	rules.start_mission(encounter)
