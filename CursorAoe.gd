extends Node2D

var conescene = load("res://addons/vision_cone_2d/vision_cone_2d_template.tscn")

var area: Area2D

var targets = {}

var shape

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func make_shape(shapename, radius):
	if shapename == "cone":
		shape = conescene.instantiate()
		shape.ray_count = 32
		shape.debug_shape = true
		shape.max_distance = radius
		area = shape.get_node("VisionConeArea")
		area.set_collision_mask_value(9, false)
		area.set_collision_mask_value(2, true)
		area.area_entered.connect(_on_area_entered)
		area.area_exited.connect(_on_area_exited)
	else:
		shape = CollisionShape2D.new()
		shape.shape = CircleShape2D.new()
		shape.shape.radius = radius
	add_child(shape)

func remove_shape():
	if shape != null:
		remove_child(shape)
	shape = null
	
func _on_area_entered(newarea):
	if newarea.entity() == "UNIT":
		targets.merge({
			newarea.id: newarea
		})
		
func _on_area_exited(area):
	if targets.has(area.id):
		targets.erase(area.id)
