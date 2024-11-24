extends VBoxContainer

@onready var rules = get_node("/root/WorldVariables")

@onready var button = get_node("Button")
@onready var prog = get_node("ProgressBar")

var title = ""

var content

var location

var pindata

var map

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var values = pindata.get_values()
	if values != {}:
		pass
		
func load_data(newpindata):
	pindata = newpindata
	var dict = pindata.get_data()
	if dict.has("name"):
		title = dict.name
		button.text = title
	if dict.has("location"):
		location = dict.location
		location.location_removed.connect(location_removed)
		
func location_removed(loc):
	clear_pin()
		
func clear_pin():
	if map != null:
		map.remove_pin(self)
		
func load_content(new):
	content = new
	button.text = content.get_name("short")
	


func _on_button_pressed() -> void:
	rules.interface.open_pin(self)
