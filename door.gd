extends Node
class_name Door

var layers = []

var squares = {}

var opened = false

var furniture: Furniture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_square(square):
	squares.merge({
		square.id: square
	})
	
func open():
	opened = true
	for key in squares:
		var square = squares[key]
		square.open_door()
		
func close():
	opened = false
	for key in squares:
		var square = squares[key]
		square.close_door()

func change_clearance(value):
	layers = [value]
	if opened:
		open()
	else:
		close()
