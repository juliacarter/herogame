extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var idlabel = get_node("VBoxContainer/IDLabel")

@onready var options = get_node("OptionButton")

@onready var influence = get_node("VBoxContainer/InfluenceList")

@onready var picker = get_node("Picker")

@onready var unitlist = get_node("VBoxContainer/RegionUnitDisplay")

@onready var prog = get_node("VBoxContainer/ScanProg")

var region

#units "parked" in the region"
var units = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_factions()

func load_factions():
	options.add_item("player")
	options.add_item("coalition")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	prog.text = String.num(region.scan_prog, 1) + "/" + String.num(region.opportunity_scan, 1)

func load_region(new):
	region = new
	idlabel.text = region.id
	influence.load_region(region)
	unitlist.load_region(region)
	region.units_landed.connect(display_units)
	
func display_units(new = []):
	unitlist.load_units()

func open_unitpicker():
	picker.load_options(self, "units", true)
	picker.visible = true

func pick_item(item, slot):
	rules.send_units(item, region)

func _on_button_pressed() -> void:
	rules.make_base_in_region(region)


func _on_button_2_pressed() -> void:
	var faction = options.get_item_text(options.selected)
	region.add_influence(faction, 0.5)


func _on_button_3_pressed() -> void:
	var faction = options.get_item_text(options.selected)
	region.remove_influence(faction, 0.5)


func _on_button_4_pressed() -> void:
	var window = rules.interface.open_window("schemes")
	window.current_tab.load_region(region)


func _on_button_5_pressed() -> void:
	open_unitpicker()
