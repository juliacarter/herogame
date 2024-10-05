extends Area2D

@onready var rules = get_node("/root/WorldVariables")
@onready var collision = get_node("CollisionShape2D")

var origin
var pos
var center

var inside = {}

var dragging = false

var selecting = "UNIT"

var rectx = 0
var recty = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	collision.shape = RectangleShape2D.new()

func _draw():
	if dragging:
		rectx = origin - center
		recty = get_global_mouse_position() - origin
		draw_rect(Rect2(origin - center, get_global_mouse_position() - origin), Color.YELLOW, false, 2.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dragging:
		update_drag()

func start_drag():
	origin = await get_global_mouse_position()
	position = origin
	dragging = true
	update_drag()

func update_drag():
	pos = await get_global_mouse_position()
	var hyp = (origin - pos)
	center = (origin + pos) / 2
	if hyp.x == 0:
		hyp.x = 0.1
	if hyp.y == 0:
		hyp.y = 0.1
	if hyp.x < 0:
		hyp.x *= -1
	if hyp.y < 0:
		hyp.y *= -1
	collision.shape.size = hyp
	global_position = center
	var result = get_overlapping_areas()
	if result != []:
		pass
	
	queue_redraw()
	
	pass
	
func stop_drag():
	dragging = false
	update_drag()
	var result
	var selected = {}
	if selecting == "SQUARE":
		result = get_overlapping_areas()
		for body in result:
			var square = body.get_parent()
			if square.entity() == selecting:
				selected.merge({
					square.id: square
				})
	else:
		result = get_overlapping_bodies()
		for body in result:
			if body.entity() == selecting:
				selected.merge({
					body.id: body
				})
	return selected
	origin = Vector2(0, 0)
	center = Vector2(0, 0)
	pos = Vector2(0, 0)
			
func detect_squares():
	set_collision_mask_value(2, false)
	set_collision_mask_value(9, true)
	selecting = "SQUARE"
	
func detect_units():
	set_collision_mask_value(9, false)
	set_collision_mask_value(2, true)
	selecting = "UNIT"
	
func detect_furniture():
	pass

func _on_body_entered(body):
	inside.merge({
		body.id: body
	})

func _on_body_exited(body):
	inside.erase(body.id)


func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.


func _on_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.
