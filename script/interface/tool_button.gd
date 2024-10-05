extends Control
class_name ToolButton

var icon_path = ""

var button_name
var action
var args = []
var index

var power

@onready var label = get_node("Label")

@onready var indicator = get_node("OnRect")
@onready var button = get_node("Button")
@onready var rules = get_node("/root/WorldVariables")

@onready var sprite = get_node("Sprite2D")

@onready var rect = get_node("SelectedRect")


# Called when the node enters the scene tree for the first time.
func _ready():
	if icon_path != "":
		sprite.texture = load("res://art/" + icon_path + ".png")
	#print("button ready")
	if(button_name != null):
		label.text = button_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rules.power == power:
		rect.visible = true
	else:
		rect.visible = false

func make_button(data):
	button_name = data.name
	icon_path = data.icon
	if is_node_ready():
		button.text = button_name
	action = data.action
	args = data.args
	power = data.power

func button_pressed():
	rules.stop_casting()
	rules.select_power(power)
	rules.callv(action, args)


func _on_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and !event.pressed:
		if event.button_index == 1:
			button_pressed()
		elif event.button_index == 2:
			power.altclick()
