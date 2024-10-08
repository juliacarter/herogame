extends Path2D

@onready var follow = get_node("PathFollow2D")

var active = false

var content

var color: Color

var origin: Vector2

var opacity = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		follow.progress += (delta * 50)
		var temp = 1 - (follow.progress_ratio + 0.5)
		if temp < 0:
			opacity = 1 - (temp * -2)
		else:
			opacity = 1
		modulate = Color(1, 1, 1, opacity)
		if follow.progress_ratio >= 1.0:
			visible = false
			queue_free()

func generate_curve(shape = "simple_horizontal_curve"):
	curve = Curve2D.new()
	var randx = (randi() % 16) - 8
	var randy = (randi() % 16) - 8
	origin = Vector2(randx, randy)
	curve.add_point(origin)
	call(shape)

func simple_horizontal_curve():
	var randx = (randi() % 64) - 32
	var randy = (randi() % 16) * -1
	var outx = (randi() % 16) - 8
	var outy = (randi() % 16) * -1
	var inx = (randi() % 16) - 8
	var iny = (randi() % 16) * -1
	var destination = origin + Vector2(randx, randy)
	curve.add_point(destination)
	curve.set_point_in(1, Vector2(inx, iny))
	curve.set_point_out(0, Vector2(outx, outy))

func drifting_upwards():
	var randx = (randi() % 16) - 8
	#var randy = (128 - (randi() % 64)) * -1
	var outx = (randi() % 32) - 16
	var outy = (randi() % 32) * -1
	var inx = (randi() % 32) - 16
	var iny = (randi() % 32) * -1
	curve.add_point(Vector2(randx, -64))
	curve.set_point_in(1, Vector2(inx, iny))
	curve.set_point_out(0, Vector2(outx, outy))
	
func load_floattext(text, pos, newcolor):
	z_index = 1
	content = Label.new()
	color = newcolor
	var setting = LabelSettings.new()
	setting.font_color = color
	content.set_label_settings(setting)
	generate_curve("drifting_upwards")
	content.text = text
	follow.add_child(content)
	active = true

func load_soundbubble(bubbledata, pos):
	
	content = Sprite2D.new()
	var i = randi() % bubbledata.bubbles.size()
	var bubblesprite = bubbledata.bubbles[i]
	generate_curve(bubbledata.path)
	var path = "res://art/" + bubblesprite + ".png"
	content.texture = load(path)
	follow.add_child(content)
	
	active = true
