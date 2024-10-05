extends Node2D

@onready var sprite = get_node("Sprite2D")

var sprites = {
	"power": load("res://art/nopower.png"),
	"dead": load("res://art/broken.png"),
	"build": load("res://art/unbuilt.png")
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_sprite(newsprite):
	sprite.texture = sprites[newsprite]
