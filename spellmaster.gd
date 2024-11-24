extends Node
class_name Spellmaster

@onready var rules = get_node("/root/WorldVariables")
@onready var data = get_node("/root/Data")

func cast_aoe_at_position(caster, target, spell):
	rules

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
