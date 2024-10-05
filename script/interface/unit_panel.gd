extends Panel

@onready var namebox = get_node("Name")
@onready var idbox = get_node("ID")
@onready var targetid = get_node("TargetID")

@onready var targetpos = get_node("target")
@onready var mypos = get_node("pos")

@onready var rules = get_node("/root/WorldVariables")

@onready var grid = get_node("GridContainer")

@onready var classpicker = get_node("ClassSelect")

@onready var holdposition = get_node("HoldPosition")

var interface

var classes = []
var current_class
var selected_class

var unit

var barscene = preload("res://scene/unit/stat_bar.tscn")

var progbars = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	print("unitpanel made")
	print(visible)
	print(position)
	interface = rules.interface
	if(interface.selected.entity() == "UNIT"):
		unit = interface.selected
		holdposition.button_pressed = unit.holding
		var items = 0
		var columns = 1
		for stat in unit.stats.fuels.keys():
			var value = unit.stats.fuels.get(stat)
			var bar = barscene.instantiate()
			bar.stat = value
			grid.add_child(bar)
	load_classes()
			
func load_classes():
	classpicker.clear()
	classpicker.add_item("none")
	classes.append(null)
	for key in rules.get_classes():
		var newclass = rules.classes[key]
		classpicker.add_item(newclass.classname)
		if newclass == unit.unit_class:
			classpicker.selected = classpicker.item_count - 1
		classes.append(newclass)

func _exit_tree():
	for child in get_children():
		child.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(interface.selected.entity() == "UNIT"):
		namebox.text = "Name = " + interface.selected.nickname
		idbox.text = "ID = " + interface.selected.id
		if(interface.selected.current_target != null):
			targetid.text = "Target = " + interface.selected.current_target.id
		
		


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
