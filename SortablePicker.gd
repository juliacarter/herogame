extends Panel

@onready var selectbutton = get_node("Select")

@onready var sortablelist = get_node("SortableList")

var sortables = [
	NameSortable.new(),
	StatSortable.new({"statname": "health"}),
	LevelSortable.new(),
]

var selection_type = "unit"

var selected = []

var multiselect = false

var parent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selectbutton.visible = multiselect


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_items(items, newsort):
	selectbutton.visible = multiselect
	sortablelist.selecting_for = self
	sortablelist.load_sortables(items, sortables)

func has_item(item):
	var i = selected.find(item)
	return i != -1

func select(item):
	if multiselect:
		if !has_item(item):
			selected.append(item)
	else:
		parent.select(item)


func _on_select_pressed() -> void:
	parent.select(selected)
