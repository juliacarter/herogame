extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var button = get_node("Button")

var event

var text = ""

var location: Vector2

var lifespan = 100.0
var time = 0

var parent

func load_toast(toastdata):
	text = toastdata.text
	
	location = toastdata.location

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.text = text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if time >= lifespan:
		expire()

func expire():
	parent.remove_toast(self)
	queue_free()

func view_event():
	rules.camera_to(location)

func _on_button_pressed() -> void:
	view_event()


func _on_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if !event.pressed:
			if event.button_index == 1:
				view_event()
			elif event.button_index == 2:
				expire()
