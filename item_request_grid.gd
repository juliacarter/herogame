extends GridContainer

var itemscene = preload("res://inventory_item.tscn")

var shelf

var stacks = []

var container

func load_items(shelf):
	for base in shelf.contents:
		var item = shelf.contents[base]
		var newitem = itemscene.instantiate()
		newitem.container = container
		newitem.stack = item
		newitem.base = item.base
		newitem.shelf = shelf
		stacks.append(newitem)
		add_child(newitem)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
