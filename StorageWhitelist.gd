extends Panel

@onready var rules = get_node("/root/WorldVariables")
@onready var data = get_node("/root/Data")

@onready var grid = get_node("CategoryBox")

var items = []

var minimscene = load("res://minimizable_list.tscn")
var buttonscene = load("res://item_whitelist_button.tscn")

var shelf: Shelf

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func clear_categories():
	for i in range(items.size()-1,-1,-1):
		var item = items[i]
		grid.remove_child(item)
		items.pop_at(i)

func load_categories(newshelf):
	shelf = newshelf
	clear_categories()
	for key in data.items:
		var newbutton = buttonscene.instantiate()
		newbutton.load_item(key, shelf)
		grid.add_child(newbutton)
		items.append(newbutton)


func _on_close_button_pressed() -> void:
	visible = false
	clear_categories()
