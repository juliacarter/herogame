extends Control

@onready var list = get_node("SortableList")

func load_units(newunits, options):
	var selectors = [
		NameSortable.new(),
		StatSortable.new({"statname": "health"})
	]
	list.load_sortables(newunits, selectors)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
