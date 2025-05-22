extends StaticBody2D
class_name Block

@onready var sprite = get_node("Sprite2D")

@onready var obstacle = get_node("Obstacle")

@onready var inside = get_node("Interior")
var obstacle_rid: RID

var solid: bool = false
var blocktype = ""
var movemod = 0.0
var spritename = ""
var spritetex
var datakey

func load_data(newdata):
	blocktype = newdata.type
	datakey = newdata.datakey
	if blocktype == "wall" || blocktype == "edge":
		solid = true
		
	spritename = newdata.sprite
	spritetex = load("res://art/" + spritename + ".png")
	set_mask()

func set_mask():
	if solid:
		set_collision_mask_value(9, true)
		set_collision_layer_value(9, true)
		set_collision_mask_value(20, true)
		set_collision_layer_value(20, true)
		if obstacle != null:
			obstacle.avoidance_enabled = true
	else:
		set_collision_mask_value(9, false)
		set_collision_layer_value(9, false)
		set_collision_mask_value(20, false)
		set_collision_layer_value(20, false)
		if obstacle != null:
			obstacle.avoidance_enabled = false

func save():
	var save_dict = {
		"type": "floor",
		"datakey": datakey,
	}
	return save_dict

# Called when the node enters the scene tree for the first time.
func _ready():
	if solid:
		obstacle.avoidance_enabled = true
	else:
		obstacle.avoidance_enabled = false
	sprite.texture = spritetex

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func type():
	return blocktype
	
func action():
	pass
