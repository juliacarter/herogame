extends GridContainer
class_name ResourceList

var boxscene = load("res://resource_box.tscn")

@onready var rules = get_node("/root/WorldVariables")

var boxes = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_resources()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_resources():
	for resource in rules.player.intangibles:
		var box = boxscene.instantiate()
		box.load_resource(resource)
		add_child(box)
		boxes.append(box)
