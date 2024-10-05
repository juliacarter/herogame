extends Panel

@onready var rules = get_node("/root/WorldVariables")

@onready var textedit = get_node("TextEdit")

var saving = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func save_prompt():
	saving = "game"
	visible = true
	
func map_prompt():
	saving = "map"
	visible = true
	
func save_game():
	var filename = textedit.text
	if filename != "":
		rules.save_game(filename)
	visible = false

func save_map():
	var filename = textedit.text
	if filename != "":
		rules.save_map(filename)
	visible = false

func _on_save_pressed() -> void:
	if saving == "game":
		save_game()
	elif saving == "map":
		save_map()
