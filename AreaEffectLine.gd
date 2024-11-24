extends AreaEffect

@onready var sprite = get_node("Sprite2D")

@onready var ray = get_node("RayCast2D")

var length = 0

var infinite = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func calculate_size():
	length = origin.distance_to(global_position)

func set_pos(new):
	#super(new)
	var target = new
	
	var newtarget = ray.to_local(target)
	if infinite:
		newtarget *= 100000
	ray.target_position = newtarget
	var pos = new
	
	var direction = origin.direction_to(pos)
	ray.force_raycast_update()
	if ray.is_colliding():
		pos = ray.get_collision_point()
	elif infinite:
		pos += (100000 * direction)
	var final = origin.move_toward(pos, max_distance)
	position = final
	calculate_size()
	
	
func set_origin(new):
	origin = new
	attack_pos = new
	los.global_position = origin
	ray.global_position = origin

func position_area():
	var offsetx = (origin.x - global_position.x) / 2
	var offsety = (origin.y - global_position.y) / 2
	var distance = global_position.distance_to(origin)
	var offset = distance / 2.0
	area.position += Vector2(offsetx, offsety)
	sprite.position = area.position
	var rad = origin.angle_to_point(area.global_position) + deg_to_rad(90)
	var deg = rad_to_deg(rad)
	area.rotate(rad)# = deg
	pass
	

func make_area():
	var newarea = Area2D.new()
	var newcol = CollisionShape2D.new()
	shape = make_rectangle()
	newcol.shape = shape
	area = newarea
	collision = newcol
	add_child(area)
	area.add_child(newcol)
	position_area()
	
func make_rectangle():
	var newshape = RectangleShape2D.new()
	newshape.size = Vector2(radius, length)
	return newshape
