extends VBoxContainer

@onready var button = get_node("Button")
@onready var prog = get_node("ProgressBar")


var content

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if content is MapJob:
		pass
	elif content is Encounter:
		pass
		
func load_content(new):
	content = new
	button.text = content.get_name("short")
	
