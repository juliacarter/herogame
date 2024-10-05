extends Camera2D

@onready var rules = get_node("/root/WorldVariables")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("camup"):
		global_position = global_position + Vector2(0, -1 * rules.scroll) * delta
		#force_update_scroll()
	if Input.is_action_pressed("camdown"):
		global_position = global_position + Vector2(0, rules.scroll) * delta
		#force_update_scroll()
	if Input.is_action_pressed("camright"):
		global_position = global_position + Vector2(rules.scroll, 0) * delta
		#force_update_scroll()
	if Input.is_action_pressed("camleft"):
		global_position = global_position + Vector2(-1 * rules.scroll, 0) * delta
		#force_update_scroll()
	
func input(event):
	pass
