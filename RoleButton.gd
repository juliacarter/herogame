extends Button

var parent

var role

var adding = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func load_role(newrole):
	role = newrole
	text = role
	



func _on_pressed():
	if adding:
		parent.add_role(role)
	else:
		parent.remove_role(role)
