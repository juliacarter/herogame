extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var list = get_node("FactionList")

@onready var info = get_node("FactionInfo")



var selected

var factions = []

var sortables = [NameSortable.new()]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	list.select_row.connect(select_row)
	load_factions()
	
func _exit_tree() -> void:
	list.select_row.disconnect(select_row)

func select_row(new):
	select_faction(new.object)

func select_faction(new):
	selected = new
	info.load_faction(selected)
	

func load_factions():
	factions = []
	for key in rules.factions:
		var faction = rules.factions[key]
		factions.append(faction)
	list.load_sortables(factions, sortables)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
