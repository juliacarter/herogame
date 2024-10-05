extends Button

@onready var rules = get_node("/root/WorldVariables")

var parent

var unit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func load_unit(newunit):
	unit = newunit
	if unit != null:
		text = unit.firstname + unit.id

func _on_pressed():
	rules.select(unit)
