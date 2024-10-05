extends HBoxContainer

@onready var rules = get_node("/root/WorldVariables")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	



func _on_pause_pressed() -> void:
	rules.pause(true)



func _on_fast_forward_pressed() -> void:
	rules.time_setting(2.0)
	



func _on_very_fast_forward_pressed() -> void:
	rules.time_setting(4.0)


func _on_play_pressed() -> void:
	rules.time_setting(1.0)
