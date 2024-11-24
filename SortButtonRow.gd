extends Control

var sortables = []

var buttons = {}

@onready var holder = get_node("Holder")

@onready var spacer = get_node("Spacer")

var needs_space = true

#@onready var buttonholder = get_node("Buttons")

var parent

var buttonscene = load("res://sort_button.tscn")
var spacerscene = load("res://sort_spacer.tscn")

func clear_sortables():
	var to_erase = []
	for key in buttons:
		to_erase.append(key)
		var button = buttons[key]
		holder.remove_child(button)
	for key in to_erase:
		buttons.erase(key)

func load_sortables(new):
	clear_sortables()
	for sortable in new:
		if sortable.sorts:
			sortables.append(sortable)
			var button = buttonscene.instantiate()
			
			button.parent = parent
			buttons.merge({
				sortable.title: button
			})
			holder.add_child(button)
			button.load_sort(sortable)
		else:
			sortables.append(sortable)
			var spacer = spacerscene.instantiate()
			holder.add_child(spacer)
			buttons.merge({
				sortable.title: spacer
			})
	if needs_space:
		holder.add_child(spacer)
	else:
		holder.remove_child(spacer)
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
