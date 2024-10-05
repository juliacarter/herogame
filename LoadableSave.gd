extends Button

@onready var rules = get_node("/root/WorldVariables")

var path

var loading = ""

var loader
var mainmenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func prepare_save(newpath):
	text = newpath
	path = newpath


func _on_pressed() -> void:
	if loading == "map":
		rules.new_game_load_map("user://maps/" + path)
	elif loading == "game":
		rules.load_game("user://saves/" + path)
	mainmenu.visible = false
