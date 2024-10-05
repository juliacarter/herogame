extends Control
class_name PlacementPanel

var buttonscene = load("res://placement_button.tscn")

@onready var grid = get_node("GridContainer")

var units = {}

var buttons = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func clear_units():
	for i in range(units.keys().size()-1,-1,-1):
		var key = units.keys()[i]
		var unit = units[key]
		var button = units[key]
		grid.remove_child(button)
		units.erase(key)
	
func load_units(newunits):
	clear_units()
	for key in newunits:
		var unit = newunits[key]
		var button = buttonscene.instantiate()
		button.load_unit(unit)
		grid.add_child(button)
		units.merge({
			unit.id: unit
		})
		buttons.merge({
			unit.id: button
		})
