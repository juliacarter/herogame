extends Control

@onready var itemholder = get_node("Items")

var rowscene = load("res://organizable_action_item.tscn")

var order = PriorityQueue.new()
var rows = []

signal item_moved(item, amount)

func clear_items():
	for i in range(rows.size()-1,-1,-1):
		var row = rows[i]
		rows.pop_at(i)
		itemholder.remove_child(row)

func load_items(new):
	clear_items()
	for item in new:
		var row = rowscene.instantiate()
		rows.append(row)
		row.parent = self
		order.insert
		itemholder.add_child(row)
		row.load_action(item)

func move_item(item, amount):
	#var pos = items.find(item)
	#if pos != -1:
	item_moved.emit(item, amount)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
