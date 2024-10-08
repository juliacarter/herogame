extends Path2D

@onready var follow = get_node("PathFollow2D")

@onready var sprite = get_node("PathFollow2D/Sprite2D")

var active = false

#the animation, if any, performed by the beam
var animation

var caster
var targetpos

var lifespan = 0.0

var speed = 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	follow.progress += (delta * 100)
	if follow.progress_ratio >= 1.0:
		hide_beam()

func load_animation(anim):
	speed = anim.speed
	if anim.sprite != "":
		var path = "res://art/" + anim.sprite + ".png"
		sprite.texture = load(path)

func show_beam():
	visible = true
	active = true
	lifespan = 1.0
	
func hide_beam():
	visible = false
	active = false
	lifespan = 0.0
	queue_free()
	
func cast(newcast, newtarg):
	curve.set_point_position(0, newcast)
	curve.set_point_position(1, newtarg)
	visible = true
	#await get_tree().create_timer(1.0).timeout
	#visible = false
