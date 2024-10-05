extends Panel

var depot = false

var furniture

@onready var grid = get_node("GridContainer")
@onready var data = get_node("/root/Data")
@onready var activate = get_node("DepotActivator")

@onready var whitelist = get_node("StorageWhitelist")

var stacks = []
var shelves = {}

var itemscene = load("res://inventory_item.tscn")
var requestscene = load("res://item_request_grid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_furniture(newfurn):
	visible = true
	furniture = newfurn
	depot = newfurn.depot
	if furniture.depot:
		activate.visible = true
		if furniture.rules.current_map.active_depot == furniture:
			activate.text = "Deactivate Depot"
		else:
			activate.text = "Activate Depot"
	else:
		activate.visible = false
	clear_items()
	get_items()
	
func clear_items():
	shelves = {}
	for i in range(stacks.size()-1,-1,-1):
		var stack = stacks[i]
		grid.remove_child(stack)
		stacks.pop_at(i)
	
func get_items():
	clear_items()
	#if !depot:
	for key in furniture.shelves:
		var shelf = furniture.shelves[key]
		var newreq = requestscene.instantiate()
		newreq.container = furniture
		newreq.shelf = shelf
		newreq.load_items(shelf)
		stacks.append(newreq)
		shelves.merge({
			key: newreq
		})
		grid.add_child(newreq)
	#else:
	#	for key in data.items:
	#		var base = data.items[key]
	#		var newitem = itemscene.instantiate()
	#		newitem.container = furniture
	#		newitem.base = base
	#		newitem.shelf = furniture.shelves.storage
	#		newitem.depot = true
	#		stacks.append(newitem)
	#		grid.add_child(newitem)
	pass



func _on_request_pressed():
	if !depot:
		for key in shelves:
			var shelf = shelves[key]
			for stack in shelf.stacks:
				stack.request()
	else:
		for stack in stacks:
			stack.request()

func _on_button_pressed():
	visible = false


func _on_whitelist_button_pressed() -> void:
	if shelves.has("storage"):
		whitelist.load_categories(shelves.storage.shelf)
		whitelist.visible = true
