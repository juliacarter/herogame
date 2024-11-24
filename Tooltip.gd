extends VBoxContainer

@onready var text = get_node("TippableRichText")

@onready var rules = get_node("/root/WorldVariables")

@onready var lockprog = get_node("HBoxContainer/ProgressBar")

@onready var data = get_node("/root/Data")

@onready var window = get_node("TippableRichText/OuterWindow")

@onready var head = get_node("TooltipHead")

var tipscenes = {
	"TextTip": load("res://TextTip.tscn"),
}

var origin

var parent

var source

#The direction the tooltip is displayed
var up = false

#var text = ""

var locked = false

var open = false

var hovered = false

var mouse_on = false

#time until an unlocked tooltip locks
var lock_timer = 1.0

var tooltipdata

var tips = []

var active_tooltip

#time until a locked tooltip unlocks
var unlock_timer = 22.0

signal tooltip_locked

signal tooltip_unlocked

signal tooltip_opened

signal tooltip_closed

var adjust_up = true
var adjust_right = true

var anchor

#distance of the outer corner to the center of the tooltip
var corner

var toggled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	head.tooltip = self
	for tip in tips:
		tip.text.last_tooltip = self

func check_hover():
	if mouse_on:
		return true
	if hovered:
		return true
	if active_tooltip != null:
		return active_tooltip.check_hover()
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var active = check_hover()
	
	
	
	if !locked && !active:
		clear_tooltip()
	if !locked:
		
		if open && active:
			if lock_timer > 0 && !toggled:
				lock_timer -= delta
			else:
				lock_tooltip()
	else:
		if active:
			unlock_timer = 22.0
		else:
			if unlock_timer > 0 && !toggled:
				if !toggled:
					unlock_timer -= delta
			else:
				unlock_tooltip()
		

func lock_tooltip():
	if parent != null:
		parent.detach_tooltip()
	locked = true
	tooltip_locked.emit()
	
func unlock_tooltip():
	locked = false
	tooltip_unlocked.emit()
	clear_tooltip()

func open_tooltip(new):
	open = true
	tooltipdata = new
	head.load_tip(tooltipdata)
	load_tip(tooltipdata)
	#text = new
	#label.text = text
	visible = true
	
func adjust_position():
	position += corner
	
func get_corner():
	var offsetx = 0
	var offsety = 0
	if adjust_right:
		offsetx = 4#size.x
	else:
		offsetx = (size.x * -1.0)-4
	if adjust_up:
		offsety = (size.y * -1.0)-4
	else:
		offsety = 4#(size.y)
	corner = Vector2(offsetx, offsety)
	
func check_adjust():
	var extent = get_viewport().size
	var adjust = size + Vector2(4, 4)
	if !adjust_right:
		adjust.x *= -1
	if adjust_up:
		adjust.y *= -1
	var final = position + adjust
	if final.x > extent.x:
		adjust_right = false
	elif final.x < 0:
		adjust_right = true
	if final.y > extent.y:
		adjust_up = true
	elif final.y < 0:
		adjust_up = false
	
func change_position(new):
	position = new
	anchor = new
	check_adjust()
	get_corner()
	adjust_position()
	
func load_tip(new):
	tooltipdata = new
	for tipdata in tooltipdata.tips:
		if tipscenes.has(tipdata.type):
			var tip = tipscenes[tipdata.type].instantiate()
			add_child(tip)
			tip.load_tip(tipdata)
			tip.text.tooltip_hovered.connect(_on_tippable_rich_text_tooltip_hovered)
			tip.text.tooltip_unhovered.connect(_on_tippable_rich_text_tooltip_unhovered)
			tips.append(tip)
	
func load_text(new):
	
	text.load_text(new)
	
func clear_tooltip():
	if source != null:
		source.active_tooltip = null
	if parent != null:
		parent.detach_tooltip()
	if active_tooltip != null:
		active_tooltip.clear_tooltip()
	open = false
	#text = ""
	visible = false
	rules.interface.remove_tooltip(self)

#to create a hyperlink capable of displaying a nested tooltip when hovered:
#delineate tooltips: |TOOLTIPNAME`text to tooltip|
#label.append_text(everything up to the tooltip)
#label.push_meta(tooltip data)
#label.add_text(text that becomes a link)
#label.pop()
#label.append_text(everything up to next tooltip)

func nest_tooltip(tip):
	if active_tooltip != null:
		active_tooltip.clear_tooltip()
	active_tooltip = rules.interface.make_tooltip(tip, true)
	if active_tooltip != null:
		active_tooltip.adjust_up = adjust_up
		active_tooltip.adjust_right = adjust_right
		active_tooltip.hovered = true


func _on_label_meta_clicked(meta: Variant) -> void:
	pass # Replace with function body.


func _on_label_mouse_entered() -> void:
	mouse_on = true


func _on_label_mouse_exited() -> void:
	mouse_on = false


func _on_mouse_entered() -> void:
	mouse_on = true


func _on_mouse_exited() -> void:
	mouse_on = false


func _on_tippable_rich_text_tooltip_hovered(tip: Variant) -> void:
	nest_tooltip(tip)


func _on_tippable_rich_text_tooltip_unhovered(tip: Variant) -> void:
	if active_tooltip != null:
		active_tooltip.hovered = false

func toggle_lock():
	if !toggled:
		toggled = true
		
	else:
		toggled = false

func _on_toggle_pressed() -> void:
	clear_tooltip()
