extends Panel

@onready var list = get_node("ScrollContainer/VBoxContainer")

var savescene = load("res://loadable_save.tscn")

var mainmenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_game_pick_save():
	visible = true
	var dir = DirAccess.open("user://saves")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				var save = FileAccess.open(file_name, FileAccess.READ)
				var button = savescene.instantiate()
				button.prepare_save(file_name)
				button.loading = "game"
				button.loader = self
				button.mainmenu = mainmenu
				list.add_child(button)
				print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func new_game_pick_map():
	visible = true
	var dir = DirAccess.open("user://maps")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				var save = FileAccess.open(file_name, FileAccess.READ)
				var button = savescene.instantiate()
				button.prepare_save(file_name)
				button.loading = "map"
				button.loader = self
				button.mainmenu = mainmenu
				list.add_child(button)
				print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
