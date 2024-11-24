extends Panel

@onready var rules = get_node("/root/WorldVariables")
@onready var data = get_node("/root/Data")

@onready var grid = get_node("GridContainer")

@onready var countlabel = get_node("Count")

var buttonscene = load("res://lesson_button.tscn")

var options = {}

var unit

signal lesson_picked

signal closed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func clear_options():
	var to_remove = []
	for key in options:
		var button = options[key]
		grid.remove_child(button)
		to_remove.append(key)
	for key in to_remove:
		options.erase(key)
		
func load_options():
	pass

func load_unit(new):
	unit = new
	clear_options()
	countlabel.text = "Available Picks: " + String.num(unit.lesson_picks)
	for key in data.upgrades:
		var upgrade = data.upgrades[key]
		if upgrade.learnable:
			var can = upgrade.check_prerequisites(unit)
			if unit.find_upgrade(upgrade) != -1:
				can = false
			if can:
				var button = buttonscene.instantiate()
				
				button.load_lesson(upgrade, unit)
				grid.add_child(button)
				button.lesson_picked.connect(_lesson_picked)
				options.merge({
					key: button
				})

func _lesson_picked():
	lesson_picked.emit()


func _on_close_pressed() -> void:
	visible = false
	closed.emit()
