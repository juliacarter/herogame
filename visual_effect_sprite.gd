extends Sprite2D

@onready var animplayer = get_node("AnimationPlayer")

var lifetime = 10.0

var animation = ""

var world

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0:
		visible = false

func load_animation(anim):
	if anim.sprite != "":
		var path = "res://art/" + anim.sprite + ".png"
		texture = load(path)
	if anim.lifetime != 0.0:
		lifetime = anim.lifetime
	if anim.animation != "":
		animation = anim.animation

func cast(newcast, newtarg):
	position = newcast
	visible = true
	animplayer.play(animation)
