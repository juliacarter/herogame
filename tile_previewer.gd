extends Sprite2D

var tilebase = {}

var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func load_tile(tiledata):
	tilebase = tiledata
	texture = load("res://art/" + tiledata.sprite + ".png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
