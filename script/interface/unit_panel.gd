extends Panel

@onready var namebox = get_node("%Name")
@onready var idbox = get_node("ID")
@onready var targetid = get_node("TargetID")

@onready var levellabel = get_node("%Level")

@onready var targetpos = get_node("target")
@onready var mypos = get_node("pos")

@onready var rules = get_node("/root/WorldVariables")

@onready var grid = get_node("GridContainer")

@onready var classpicker = get_node("ClassSelect")

@onready var holdposition = get_node("HoldPosition")

@onready var healthbar = get_node("HealthBar")

@onready var focusbar = get_node("VBoxContainer/FocusBar")
@onready var focusgain = get_node("HBoxContainer/FocusGain")

@onready var statuslabel = get_node("%StatusLabel")

@onready var armorlabel = get_node("SurvivabilityInfo/ArmorLabel")

@onready var moralebar = get_node("VBoxContainer/MoraleBar")

@onready var experience = get_node("ExperienceBar")

@onready var buffs = get_node("BuffDisplay")

@onready var aggro = get_node("AggroTableDisplay")

var interface

var classes = []
var current_class
var selected_class

var unit

var barscene = preload("res://scene/unit/stat_bar.tscn")

var progbars = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
			
func load_classes():
	pass
	
func load_unit(new):
	unit = new
	healthbar.stat = unit.stats.fuels.health
	focusbar.stat = unit.stats.fuels.energy
	moralebar.stat = unit.stats.fuels.morale
	aggro.load_aggro(unit.aggrotable)
	experience.load_unit(unit)
	buffs.load_unit(unit)

func _exit_tree():
	for child in get_children():
		child.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if unit != null:
		namebox.text = unit.object_name()
		idbox.text = "ID:" + unit.id
		statuslabel.text = unit.status()
		levellabel.text = "Lv." + String.num(unit.level, 0)
		armorlabel.text = "ARMOR: " + String.num(unit.defense.armor.physical.variance) + " | " + String.num(unit.defense.armor.energy.variance)
		#get_fuels()
		
		
func get_fuels():
	var healthmax = unit.stats.fuels.health.max
	var healthcurrent = unit.stats.fuels.health.value
	healthbar.max_value = healthmax
	healthbar.value = healthcurrent
	
	var focusmax = unit.stats.fuels.energy.max
	var focuscurrent = unit.stats.fuels.energy.value
	focusbar.max_value = focusmax
	focusbar.value = focuscurrent


func _on_check_box_toggled(button_pressed):
	if(interface.selected.entity() == "UNIT"):
		interface.selected.verbose = true


func _on_button_pressed():
	rules.interface.open_window("unitinv")
	rules.interface.windows.unitinv.set_unit(interface.selected)


func _on_class_select_item_selected(index):
	selected_class = classes[index]
	pass


func _on_class_save_pressed():
	unit.change_class(selected_class)


func _on_hold_position_toggled(toggled_on):
	unit.holding = toggled_on


func _on_lessons_pressed() -> void:
	rules.interface.open_window("unitlessons")
	rules.interface.windows.unitlessons.set_unit(interface.selected)


func _on_open_main_pressed() -> void:
	rules.interface.open_window("singleunit")
	rules.interface.windows.singleunit.current_tab.load_unit(interface.selected)


func _on_button_2_pressed() -> void:
	rules.interface.open_character_sheet(unit)


func _on_kill_pressed() -> void:
	unit.die()
