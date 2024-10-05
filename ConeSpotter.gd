extends Node2D
class_name ConeSpotter

@onready var cone = get_node("VisionCone2D")
@onready var area = get_node("VisionCone2D/VisionConeArea")

var angle
var distance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_spotter(spotterdata):
	angle = spotterdata.angle
	cone.angle_deg = angle
	distance = spotterdata.distance
	cone.max_distance = distance
