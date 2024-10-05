extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var clothesholder = get_node("ClotheSlots")
@onready var toolholder = get_node("ToolSlots")

@onready var picker = get_node("Picker")

var slotscene = load("res://equipment_button.tscn")

var clotheslots = {}
var toolslots = []

var parent

var unit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func clear_slots():
	var removed = []
	for key in clotheslots:
		var slot = clotheslots[key]
		clothesholder.remove_child(slot)
		removed.append(key)
	for key in removed:
		clotheslots.erase(key)

func pick_item(item, picking_slot):
	unit.set_equipment(picking_slot, item)

func load_slots(newunit):
	unit = newunit
	clear_slots()
	for slotname in unit.equipment:
		var slot = slotscene.instantiate()
		slot.parent = self
		slot.slotname = slotname
		slot.text = slotname
		clotheslots.merge({slotname: slot})
		clothesholder.add_child(slot)
		
func open_equipmentpicker(slotname):
	picker.load_equipment_options(self, slotname, false)
	picker.visible = true
	
