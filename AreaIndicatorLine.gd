extends AreaIndicator
class_name AreaIndicatorLine

@onready var line = get_node("Line2D")

@onready var ray = get_node("Raycasts/Forward")

@onready var raycast

var length = 0

var points = []

func set_radius(rad):
	super(rad)
	line.width = radius

func _init():
	pass

func set_origin(new):
	pass
	super(new)
	line.points[0] = origin
	ray.position = origin
	pass
	
func update_position(new):
	var target = ray.to_local(new)
	var target_dir = origin.direction_to(target)
	if infinite:
		target *= 1000000
	ray.target_position = target
	var pos = new
	
	var direction = origin.direction_to(pos)
	ray.force_raycast_update()
	if ray.is_colliding():
		pos = ray.get_collision_point()
	elif infinite:
		pos += (100000 * direction)
	var final = (to_global(origin)).move_toward(pos, max_distance)
	final = to_local(final)
	line.points[1] = final
	length = origin.distance_to(final)
	#generate_points()
	
func generate_points():
	var result = []
	var point1 = to_global(Vector2(-(radius/2), 0))
	var point2 = to_global(Vector2(radius/2, 0))
	var point3 = to_global(Vector2(-(radius/2), -(length)))
	var point4 = to_global(Vector2(radius/2, -(length)))
	points = [point1, point2, point3, point4]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _draw():
	if points != []:
		draw_polygon(points, [Color.RED])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
