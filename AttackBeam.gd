extends Line2D

var caster
var targetpos

var lifespan = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
func show_beam():
	visible = true
	lifespan = 1.0
	
func hide_beam():
	visible = false
	lifespan = 0.0
	
func cast(newcast, newtarg):
	points[0] = newcast
	points[1] = newtarg
	visible = true
	await get_tree().create_timer(0.2).timeout
	visible = false
