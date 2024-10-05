extends Control

@onready var rules = get_node("/root/WorldVariables")
@onready var data = get_node("/root/Data")
@onready var bars = {"main": get_node("MainBar"), "debug": get_node("DebugBar")}
@onready var buttons = get_node("ButtonContainer")
@onready var categorybars = {}
@onready var categorybuttons ={}
var toolbarscene = preload("res://scene/interface/toolbar.tscn")
var toolbarbuttonscene = preload("res://scene/interface/toolbar_button.tscn")

signal bar_opened

# Called when the node enters the scene tree for the first time.

		
func _exit_tree():
	for child in get_children():
		child.queue_free()

func open_bar(bar):
	print(bars)
	for b in bars.values():
		b.open(false)
	bars.get(bar).open(true)
	bar_opened.emit()
	
func close_bars():
	for b in bars.values():
		b.open(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_tool_button_pressed():
	open_bar("main")


func _on_button_pressed():
	open_bar("furniture")


func _on_debug_pressed():
	open_bar("debug")
