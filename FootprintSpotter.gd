extends Node2D
class_name FootprintSpotter

@onready var rules = get_node("/root/WorldVariables")

@onready var area = get_node("Area2D")
var collision

var furniture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_spotter({}, furniture)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_spotter(spotterdata, newfurn):
	furniture = newfurn
	if is_node_ready():
		collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		collision.shape = shape
		collision.debug_color = Color.RED
		area.add_child(collision)
		shape.size.x = newfurn.size.x * rules.squaresize
		shape.size.y = newfurn.size.y * rules.squaresize
		pass
