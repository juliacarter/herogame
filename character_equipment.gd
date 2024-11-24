extends Control

signal equipment_pressed(item)

var buttonscene = load("res://equipment_button.tscn")

var buttons = []

var unit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func clear_buttons():
	for i in range(buttons.size()-1,-1,-1):
		var button = buttons[i]
		remove_child(button)
		buttons.pop_at(i)
	
func load_unit(new):
	clear_buttons()
	unit = new
	for item in unit.equipped:
		var button = buttonscene.instantiate()
		button.equipment_pressed.connect(equipment_clicked)
		button.unit = unit
		add_child(button)
		button.load_item(item)
		buttons.append(button)
	var button = buttonscene.instantiate()
	button.equipment_pressed.connect(equipment_clicked)
	button.unit = unit
	add_child(button)
	buttons.append(button)
		
func equipment_clicked(item):
	equipment_pressed.emit(item)
