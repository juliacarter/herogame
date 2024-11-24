extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var list = get_node("SortableList")

var sortables = [
	NameSortable.new({"displayscene": "TextButtonSortableDisplay"}),
	StatSortable.new({"statname": "health"}),
	LevelSortable.new(),
	CheckboxSortable.new(),
]

func load_units():
	var units = rules.home.units
	var options = []
	for key in units:
		var unit = units[key]
		options.append(unit)
	await list.load_sortables(options,sortables)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	list.selecting_for = self
	await load_units()

func select(object):
	pass
	
func toggle(object, status):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_disband_pressed() -> void:
	var options = list.selected
	for row in options:
		row.object.die()
	load_units()
