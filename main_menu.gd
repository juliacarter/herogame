extends Control

@onready var rules = get_node("/root/WorldVariables")
@onready var loader = get_node("Loader")
@onready var mapgen = get_node("MapGeneration")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loader.mainmenu = self
	rules.mainmenu = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_new_game_pressed() -> void:
	mapgen.visible = true


func _on_continue_pressed() -> void:
	loader.load_game_pick_save()


func _on_load_map_pressed() -> void:
	#visible = false
	loader.new_game_pick_map()
