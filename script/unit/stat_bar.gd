extends HBoxContainer

@onready var rules = get_node("/root/WorldVariables")

@onready var bar = get_node("StatBar")

@onready var gain = get_node("StatBar/GainLabel")

@onready var damage = get_node("StatBar/DamageBar")

@onready var label = get_node("StatBar/NumberVal")

@onready var box = get_node("StatEditor/SpinBox")

@onready var editor = get_node("StatEditor")

@onready var tooltip = get_node("StatBar/TextureRect/TooltipArea")

@onready var data = get_node("/root/Data")

var tooltipname = "testtip"

var stat

var can_edit = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if !rules.debugvars.editstats:
		remove_child(editor)
		can_edit = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stat != null:
		#if can_edit:
			#box.max_value = stat.max
		bar.max_value = stat.max
		var cap = stat.current_max()
		bar.value = stat.value
		gain.text = String.num(stat.visual_gain(), 1) + "/s"
		if cap != stat.max:
			label.text = String.num(stat.value, 1) + "/" + String.num(cap, 1) + "(" + String.num(stat.max) + ")"
		else:
			label.text = String.num(stat.value, 1) + "/" + String.num(stat.max)
		damage.max_value = stat.max
		damage.value = stat.damage
		tooltip.tooltip = data.tooltips[tooltipname]


func _on_button_pressed() -> void:
	stat.set_value(box.value)
