extends Button

@onready var rules = get_node("/root/WorldVariables")

var unit: Unit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func load_unit(newunit):
	unit = newunit
	text = unit.object_name()


func _on_pressed() -> void:
	rules.select(unit)
