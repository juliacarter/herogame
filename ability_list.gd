extends GridContainer

var buttonscene = load("res://ability_button.tscn")

var abilities = []

var buttons = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func clear_abilities()

func load_abilities(newabilities):
	for ability in newabilities:
		var button = buttonscene.instantiate()
		buttons.append(button)
		add_child(button)
