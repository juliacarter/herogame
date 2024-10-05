extends Node2D

@onready var area = get_node("Area2D")

var zonename = "default"

var id

var squareshape = RectangleShape2D.new()

var squares = {}
var shapes = {}

var topleft = Vector2(10000000, 1000000)
var botright: Vector2

var rect

func save():
	var saved_squares = []
	for square in squares:
		saved_squares.append({"x": square.x, "y": square.y})
	var save_dict = {
		"id": id,
		"zonename": zonename,
		"squares": saved_squares,
	}
	return save_dict

func load_save(savedata):
	id = savedata.id
	zonename = savedata.zonename
	load_squares(savedata.squares)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	squareshape.size = Vector2(64, 64)
	for key in shapes:
		var shape = shapes[key]
		area.add_child(shape)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_random_square(needs_nav = false):
	if squares.keys().size() > 0:
		var rand = randi() % squares.keys().size()
		var key = squares.keys()[rand]
		if squares.has(key):
			return squares[key]
	else:
		return null

func remove_square(squareid):
	if shapes.has(squareid):
		remove_child(shapes[squareid])
	squares.erase(squareid)
	shapes.erase(squareid)


func make_zone():
	if rect != null:
		remove_child(rect)
	rect = ColorRect.new()
	#rect.position = topleft
	rect.color = Color(29.0, 129.0, 211.0, 0.5)
	rect.size = botright - topleft
	add_child(rect)

func load_squares(newsquares):
	for square in newsquares:
		#var square = newsquares[key]
		if square.position < topleft:
			topleft = square.position - Vector2(32, 32)
		if square.position > botright:
			botright = square.position - Vector2(32, 32)
		square.set_zone(zonename, self)
		var collision = CollisionShape2D.new()
		#var rect = Rect2(square.global_position, square.size)
		#draw_rect(rect, Color.GREEN)
		collision.shape = squareshape
		collision.position = square.position
		collision.debug_color = Color("CRIMSON")
		square.make_zonevis()
		#square.make_zonevis()
		squares.merge({
			square.id: square
		})
		shapes.merge({
			square.id: collision
		})
		if is_node_ready():
			area.add_child(collision)
	position = topleft
	#make_zone()
		
