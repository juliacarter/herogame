extends Panel

@onready var rules = get_node("/root/WorldVariables")
@onready var grid = get_node("GridContainer")

signal item_picked(item, slot)

var buttonscene = load("res://picker_button.tscn")
var checkscene = load("res://picker_check_button.tscn")

var buttons = []

var picking_for
var picking_slot

var multipick = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func pick_item(item):
	item_picked.emit(item, picking_slot)
	picking_for.pick_item(item, picking_slot)
	visible = false
	
func remove_item(item):
	picking_for.remove_item(item, picking_slot)
	
func commit_selection():
	var result = []
	for button in buttons:
		if button.button_pressed:
			result.append(button.item)
	pick_item(result)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func clear_options():
	for button in buttons:
		grid.remove_child(button)
	buttons = []

func load_options(button, slot, multi = false):
	clear_options()
	multipick = multi
	var options = rules.get_picker_options(slot)
	picking_for = button
	picking_slot = slot
	if options != null:
		load_buttons(options, multi)
			
func load_equipment_options(button, slotname, multi = false):
	clear_options()
	var options = rules.get_picker_equipment_options(slotname)
	picking_for = button
	picking_slot = slotname
	if options != null:
		load_buttons(options, multi)
		
func load_buttons(options, multi = false):
	for option in options:
		var newbutton
		if multi:
			newbutton = checkscene.instantiate()
		else:
			newbutton = buttonscene.instantiate()
		newbutton.item = option
		if !(option is Unit) && (option is Asset):
			newbutton.text = option.name()
		elif option is Unit:
			newbutton.text = option.object_name()
		else:
			newbutton.text = option
		buttons.append(newbutton)
		newbutton.picker = self
		grid.add_child(newbutton)
		

func _on_confirm_pressed() -> void:
	commit_selection()


func _on_close_pressed() -> void:
	visible = false
