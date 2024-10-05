extends Panel

@onready var slotholder = get_node("Slots")
@onready var selector = get_node("EquipmentSelector")

var slotscene = load("res://equipment_slot.tscn")

var slots = {}

var unit


# Called when the node enters the scene tree for the first time.
func _ready():
	selector.parent = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for key in slots:
		var slot = slots[key]
		var item = unit.equipment[key]
		if item == null:
			slot.text = key
		else:
			slot.text = key + ": " + item.base.itemname

func open_slot(slot):
	selector.load_options(slot)
	selector.visible = true

func request_equipment(base, slot):
	unit.find_and_equip(base, slot)

func set_unit(newunit):
	visible = true
	unit = newunit
	for slot in newunit.equipment:
		var newslot = slotscene.instantiate()
		var item = newunit.equipment[slot]
		slots.merge({
			slot: newslot
		})
		if item == null:
			newslot.text = slot
		else:
			newslot.text = slot + ": " + item.base.itemname
		newslot.unit = newunit
		newslot.slot = slot
		newslot.parent = self
		if unit.equipment[slot] != null:
			newslot.item = unit.equipment[slot]
		slotholder.add_child(newslot)

func load_items(shelf):
	for key in shelf.contents:
		var item = shelf.contents[key]


func _on_button_pressed():
	visible = false
