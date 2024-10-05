extends WorldObject
class_name FloorItem

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var rules = get_node("/root/WorldVariables")
@onready var sprite = get_node("Sprite2D")

@onready var highlight = get_node("Hovered")

@onready var label = get_node("Label")

var selectable = true

var id = -1

var item
var shelf = Shelf.new({"name": "storage"})

var map

var square

var can_interact = {}

func save():
	var save_dict = ({
		"id": id,
		"map": map.id,
		"position": {"x": position.x, "y": position.y},
		"item": item.save(),
	})
	return save_dict
	
func load_save(savedata):
	id = savedata.id
	position = Vector2(savedata.position.x, savedata.position.y)
	item = Stack.new(savedata.item.count, savedata.item.base, map)

# Called when the node enters the scene tree for the first time.
func _ready():
	id = rules.uuid(self)
	shelf.location = self
	print(global_position)
	print(visible)
	if item != null:
		sprite.texture = load("res://art/" + item.base.sprite + ".png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if item != null:
		label.text = String.num(item.count)

func get_square(origin = null, reserving = false, spotname = "on"):
	return square
	
func attach_item(newitem):
	newitem.location = self
	shelf.store(newitem)
	item = newitem
	if is_node_ready():
		sprite.texture = load("res://art/" + newitem.base.sprite + ".png")
	

func entity():
	return "FLOORSTACK"

func take_from(base, count):
	var newstack = shelf.split(base, count)
	if newstack.count <= 0:
		map.remove_floorstack(self)
	return newstack

func _on_area_entered(body):
	if(body.entity() == "UNIT"):
		can_interact.merge({body.id: body})


func _on_area_exited(body):
	if(body.entity() == "UNIT"):
		if(can_interact.has(body.id)):
			can_interact.erase(body.id)


func _on_body_entered(body: Node2D) -> void:
	can_interact.merge({
		body.id: body
	})


func _on_body_exited(body: Node2D) -> void:
	can_interact.erase(body.id)




func _on_mouse_entered() -> void:
	await rules.hover(self)


func _on_mouse_exited() -> void:
	if rules.hovered != null:
		if rules.hovered.id == id:
			await rules.hover(null)
