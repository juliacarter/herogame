extends Node2D
class_name AreaIndicator

var active = false

var color = Color.SKY_BLUE

#the point the aoe originates from
#for lines/cones
#placed AoEs dont care about this
var origin

var radius = 32

var max_distance = 128

var parent

#whether the area goes to its max distance every time, or only to the mouse
var infinite = true

func update_range(new):
	max_distance = new

func load_aoe(aoedata):
	if aoedata.has("radius"):
		set_radius(aoedata.radius)
	if aoedata.has("max_distance"):
		max_distance = aoedata.max_distance

func set_radius(rad):
	radius = rad

func update_position(new):
	global_position = new

func set_origin(new):
	origin = new

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
