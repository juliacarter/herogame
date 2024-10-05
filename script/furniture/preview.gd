@tool
extends Node2D
class_name Preview

var furniscene = preload("res://scene/furniture/furniture.tscn")

var content: Furniture
var angle = 0
var active = false

var spot = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	content = furniscene.instantiate()
	content.disable()
	add_child(content)
	#content.z_index = 20
	#print(content.position)

func add_furniture(furniture):
	remove_child(content)
	add_child(furniture)
	
func update():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("rotate_preview_left"):
		if(angle == 3):
			angle = 0
		else:
			angle = angle + 1
		rotation_degrees = 90 * angle
		content.angle = angle
	if event.is_action_pressed("rotate_preview_right"):
		if(angle == 0):
			angle = 3
		else:
			angle = angle - 1
		rotation_degrees = 90 * angle
		content.angle = angle
