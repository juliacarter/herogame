extends Control
class_name CharacterSheetOverview

@onready var upgradelist = get_node("VBoxContainer2/VBoxContainer/UpgradeList")

@onready var lessons = get_node("LessonPicker")

@onready var stats = get_node("VBoxContainer2/VBoxContainer/HBoxContainer/CharacterSheetStatBlock")

@onready var header = get_node("VBoxContainer2/CharacterSheetHeader")

@onready var equipment = get_node("VBoxContainer2/VBoxContainer/HBoxContainer/CharacterEquipment")
@onready var equipmentpicker = get_node("EquipmentPicker")

var unit

var tabtitle = "Overview"

var sortables = [
	NameSortable.new(),
	SourceSortable.new(),
]

func get_window_title():
	return "Character Sheet - Overview"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lessons.lesson_picked.connect(load_upgrades)
	equipment.equipment_pressed.connect(equipment_pressed)
	equipmentpicker.equipment_picked.connect(pick_equipment)
	
func pick_equipment(item):
	unit.find_and_equip(item)
	
func equipment_pressed(item):
	if item == null:
		open_equipmentpicker()


func open_equipmentpicker():
	equipmentpicker.open()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_unit(new):
	unit = new
	load_upgrades()
	stats.load_unit(unit)
	header.load_unit(unit)
	equipment.load_unit(unit)
	
	
	
	
func load_upgrades():
	if unit != null:
		upgradelist.load_sortables(unit.upgrades, sortables)


func _on_lesson_button_pressed() -> void:
	lessons.visible = true
	lessons.load_unit(unit)


func _on_button_pressed() -> void:
	unit.level_up()
