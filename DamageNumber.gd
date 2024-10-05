extends Node2D

@onready var label = get_node("Label")

var value = 0.0
var color: Color

var life = 1.0
var time = 0.0

var active = false

func activate(str, newcolor):
	value = str
	color = newcolor
	var setting = LabelSettings.new()
	setting.font_color = color
	label.set_label_settings(setting)
	label.text = str
	active = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		float_up(delta)
	if time >= life:
		get_parent().remove_child(self)
		free()
	
func float_up(delta):
	time += delta
	if time >= life:
		active = false
	position -= Vector2(0, delta * 10.0)
