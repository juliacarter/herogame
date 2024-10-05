extends HBoxContainer

@onready var rules = get_node("/root/WorldVariables")

var buttonscene = load("res://view_button.tscn")

var buttons = {}

func load_views():
	for key in rules.views:
		var view = rules.views[key]
		var newbutton = buttonscene.instantiate()
		newbutton.load_view(view)
		buttons.merge({
			key: newbutton
		})
		add_child(newbutton)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_views()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
